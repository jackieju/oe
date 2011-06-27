require 'net/smtp'
require 'iconv'
require 'metaweblogapi'



class EditorController < ApplicationController
include AuthenticatedSystem
  before_filter :login_required 

  def home # show home page
    render :layout=>"appserver_layout"
  end
  
  def index
    docid = params[:docid]
    search = params[:search]
     logger.info("search="+search.to_s)
    
    logger.info("docid="+docid.to_s)
    if (docid)
      begin
        @doc = Doc.find(docid);
      rescue
        redirect_to :action=>"error", :err_msg => "文章不存在"
        return
      end
    else
      #  @doc_list = Doc.find_by_sql("select * from docs where uid=#{current_user[:id]} order by updated_at")
    end
    
    if (@doc)
      logger.info("doc="+@doc.to_s)
      @doc[:content] = @doc.loadContent()
      #logger.info("content=#{@doc[:content]}")
    end

    if (search)
     #  @doc_list = Doc.find_by_sql("select * from docs where uid=#{current_user[:id]} and title like '%#{search}%'")
      @doc_list = Doc.find_with_ferret("#{search} +uid:#{current_user[:id]}")#, {:page=>1, :limit=>10, :offset=>0})
logger.info("+title:#{search}+uid:#{current_user[:id]}")
      logger.info("--->doc_list size=#{@doc_list.total_hits}")
		@page_number = 1
    end

    #   logger.info(">>>>>>>>>>>>>>>>>doclist=#{@doc_list}")
    render :layout=>"index"
  end

  def list
    @page_size = 15

    r = ActiveRecord::Base.connection.execute("select count(*) from docs where uid=#{current_user[:id]}")
    rr = r.fetch_row[0].to_i
    @page_number = rr / @page_size
    if (@page_number *  @page_size != rr )
      @page_number = @page_number +1
    end


    @current_page = params[:page]
    if (!@current_page)
      @current_page = 1
    else 
      @current_page = @current_page.to_i
    end
    @current_page = 1 if  @current_page == 0
    current_page =  @current_page -1 

    start = @page_size*current_page
    number = @page_size
    @doc_list = Doc.find_by_sql("select * from docs where uid=#{current_user[:id]} order by updated_at desc  limit #{start},#{number} ")    
    logger.info(">>>>>>>>>>>>>>>>>doclist=#{@doc_list}")

    render :layout=>false
  end

  def create
    logger.info("user id:"+current_user[:id].to_s)
    doc = Doc.new({
      :uid=>current_user[:id],
      :title=>"",
      :doctype=>1, 
      :prop=>'',
      :tags=>''
      })
      doc.save!()
      @doc = doc

      docid = doc[:id].to_s
      redirect_to :action=>'index', :docid=>docid
    end
    
    def save_doc (doc)
      id=doc[:id]
      content=doc[:content]
      begin
        dir = id.to_i/100
        dir = "/var/oe/docs/#{dir.to_s}"
        FileUtils.makedirs(dir)
        logger.info("===========>#{dir}/#{id}<====")
        aFile = File.new("#{dir}/#{id}","w")
        aFile.puts content
        aFile.close
      rescue Exception=>e
        logger.error e
      end

      doc.save!()
    end
    
    def save
      title = params[:title]
      content = params[:content]
      id = params[:docid].strip
      # User.new({:name=>"ddd"}).save() 
      logger.info("id=>"+id)
      doc = Doc.find(id)
      if (current_user[:id]!=doc[:uid])
      render :text=>""
		return
   	  end
      doc[:title] = title.gsub("\n","").gsub("\r","");
      doc[:content] = content;

    save_doc(doc)

 

=begin
        analyzer = RMMSeg::Ferret::Analyzer.new { |tokenizer|
  Ferret::Analysis::LowerCaseFilter.new(tokenizer)
}
  a = /[a-zA-Z]+|[0-9]+|[\xe0-\xef][\x80-\xbf][\x80-\xbf]/
  analyzer2 = Ferret::Analysis::RegExpAnalyzer.new(a, true)
  
  s = analyzer2.token_stream("content", content)
while true
  ss = s.next
  if !ss
    break;
  end
logger.info("---->analyze result:#{ss}")
end
=end

=begin
s = analyzer.token_stream("title", title)
while true
  ss = s.next
  if !ss
    break;
  end
logger.info("---->analyze result:#{s.to_s}")
end





analyzer2 = Ferret::Analysis::RegExpAnalyzer.new(/\w+/, true)
s = analyzer2.token_stream("title", title)
while true
  ss = s.next
  if !ss
    break;
  end
logger.info("---->analyze result:#{ss}")
end
=end
      render :text=>""
    end

    def del
      id = params[:docid].strip
      # User.new({:name=>"ddd"}).save() 
      logger.info("id=>"+id)

	  if (current_user[:id] != Doc.find(id)[:uid] )
			redirect_to :action=>'list'
			return
	  end
      Doc.delete(id)
      dir = id.to_i/100
      dir = "/var/oe/docs/#{dir.to_s}"
      FileUtils.makedirs(dir)
      logger.info("===========>#{dir}/#{id}<====")
      begin
        File.delete("#{dir}/#{id}")
      rescue Exception=>e
        logger.error e
      end
      redirect_to :action=>'list'
    end

    def esc(str)
      print "----->str1:#{str}\n"
        str=str.gsub("&","&amp;")
        print "----->str2:#{str}\n"
       str.gsub(/([^ %&=;?:\/a-zA-Z0-9_.-]+)/n) do
      '%' + $1.unpack('H2' * $1.size).join('%').upcase
      end.tr(' ', '+')
    end

	def getTitle( content)
	 title_re = /<title>(.*?)<\/title>/mi

      m = title_re.match(content)
      print "\n---------->title:#{m}"
      if (m)
        title = m[1].gsub(/[\/|\\*\(\)?\[\];:'\",\.]/,"").gsub(/^[\s]+/, "").gsub(/[\s]+$/, "").gsub(/<!--(.*)-->/, "")
      else
        title = ""
      end

		return title
	end

    def getPage(url, limit)
      url = esc(url)
      print "--------------------------------->url1:#{url}\n"
      res = Net::HTTP.get_response(URI.parse(url))
      print "--------------------------------->locate:#{res['location']}\n";
      #print "--------------------------------->response value:#{res}\n"
      case  res
        when Net::HTTPSuccess     then return res
        when Net::HTTPRedirection 
            if (limit<=0) 
              return res 
            else 
              getPage(res['location'], limit-1)
            end
      end
      return res
    end
    
    def logit
      url = params[:url];
      uri =  URI.split(esc(url));
      url =~ /.*?:\/\/.*\//m
      context = $&
    begin
      res = getPage(url, 10)
      print "------->inspect:"+res.inspect+"\n"
         content = res.body
      rescue Exception=>e
        print "=====>exception:#{e}\n"
        content = "Cannot get page"
    end
      # get charset
      if (content =~/<meta.*? charset=[\'\"]*([-\w\d]+)[\'\"]*.*?>/mi)
      encode = $1.gsub(" ", "")
    else
      encode = "utf-8"
    end
      logger.info  "---->charset="+encode+"\n"
      if  not (encode =~ /~utf-8$/i)
begin
        content =	Iconv.conv('utf-8', encode, content)
rescue Exception=>e
	logger.info e
	title = getTitle (content)
	if (title)
		begin
			title = Iconv.conv('utf-8', encode, title)
		rescue Exception=>ee
			logger.info e
			title = "Cannot get title"
		end
	else
		title = "Cannot get title"
	end
	content = "Cannot get content"
end
      end
     # print "------>content_type:"+content.type_params[:charset]+"\n"
     # print "\n"
	title = getTitle(content) if !title
	
       #  print "\n---------->content0:#{content}"
      content_re = /<body(.*?)>(.*)<\/body>/xmi
      m = content_re.match(content)     
      if m
         print "\n---------->m:#{m}\n"
       print "\n---------->m1:#{m[1]}\n"
        print "\n---------->m2:#{m[2]}\n"
      content = m[2]
     end
      print "\n---------->content1:#{content}"
     content = content.gsub(/<script(.*?)<\/script>/mi, "")
     
     # fix img
     content = content.gsub(/(<img.*?src=[\"\'])\//){|m| "#{$1}#{uri[0]}:\/\/#{uri[2]}\/"}
     content = content.gsub(/(<img.*?src=[\"\'])([^\/(http:\/\/)])/){|m| "#{$1}#{context}#{$2}"}
     #  print "\n---------->content:#{content}"
     
     
      content = "<p style=\"background:\#ccccff\"><a href='#{params[:url]}' >#{params[:url]}</a></p>#{content}";
      doc = Doc.new({
      :uid=>current_user[:id],
      :title=>title,
      :doctype=>2, #type: bookmark 
      :prop=>'',
      :tags=>''
      })
      doc.save!()
      @doc = doc

      docid = doc[:id].to_s
      doc[:content] = content
      save_doc(doc)
      redirect_to :action=>'index', :docid=>docid

    end
    
    # publish by metaweblog api
    def pub_by_mwla
      username = params[:username]
      pwd = params[:pwd]
      url = params[:url]
      if !url
        url = ""
      else
        url = url.rstrip.strip
      end
      dest = params[:dest]
      docid = params[:docid]
      
      begin 
        Publish.pub_by_mwl(current_user, docid, username, pwd, url)
      rescue Exception=>e
        render :text=>"<script>showErrDlg('#{e.message}')</script>"
      end
      render :text=>"日志发布成功"
    end
    
    def email_doc
      @doc = Doc.find(params[:docid])
      to = params[:email]
      from = params[:from]
      @doc[:content] = @doc.loadContent()
      begin
        Publish.email_doc(current_user, params[:docid], from, to)
      rescue
        render :text=>"<script>showErrDlg('Email发送失败')</script>"
        return
      end
      render :text=>"ok"
    end

    def search_email
      begin
        userinfos = Userinfo.find_by_sql("select * from userinfos where uid=#{current_user[:id]}")
      rescue
        render :text=>""
        return
      end
      if (!userinfos || userinfos.size==0)
        render :text=>""
        return
      end
      userinfo = userinfos[0]

      pj = ActiveSupport::JSON.decode(userinfo[:prop])
      if !pj
        render :text=>""
        return
      else
        if params[:type]=="from"
          render :text=> pj["email_from"]
          return
        elsif params[:type] == "to"
          render :text=>pj["email_to"]
          return
        else
          render :text=>""
          return
        end
      end
    end

  
    
    def error
      @err_msg = params[:err_msg]
      render :layout=>"index"
    end
    
    #rebuild ferret_index
    def rebuild_ferret
        Doc.rebuild_index
        render :text=> "rebuild ferrect succesfully"
    end

  end
