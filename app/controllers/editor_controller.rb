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

    def getPage(url, limit, cookie, referer)
      url.strip!
      url = esc(url)
      print "--------------------------------->url1:#{url}\n"
      if not (url =~ /http\:\/\//i)
          url = "http://"+url
      end
      uri =URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      headers = {}
      if cookie
          headers['Cookie'] = cookie
      end
      if referer
          header['Referer'] = referer
      end
      p "==>uri.scheme=#{uri.scheme},uri.host=#{uri.host}, uri.path=#{uri.path}, uri.query=#{uri.query}"
      path = "/"
      if uri.path  and uri.path.length > 0
          path = uri.path
     end
     p "===>path=#{path}"
=begin
      resp, d = http.get(path, uri.query, headers)
#      p "---->resp.inspect=#{resp.response['set-cookie']}"
 #     p "---->resp.req=#{uri.host}\n#{uri.port}\n#{uri.path}\n#{uri.query}\n#{headers.inspect}"
      if (resp.response['set-cookie'])
          cookie1 = resp.response['set-cookie'].split('; ')[0]
      end
    
    case  resp
        when Net::HTTPSuccess     then return resp
        when Net::HTTPRedirection 
            if (limit<=0) 
              return resp 
            else 
              getPage(resp['location'], limit-1, cookie1, url)
            end
      end
      return resp
=end
      
      p "==>33#{url}"
      res = Net::HTTP.get_response(URI.parse(url))
   #   cookie1 = res['set-cookie'].split('; ')[0]
      p "--->cookie=#{cookie.inspect}"
      #print "------->body:"+res.body+"\n"
      print "--------------------------------->locate:#{res['location']}\n";
      #print "--------------------------------->response value:#{res}\n"

      case  res
        when Net::HTTPSuccess     then return res
        when Net::HTTPRedirection 
            if (limit<=0) 
              return res 
            else 
              getPage(res['location'], limit-1, cookie1, url)
            end
      end
      
      return res

    end
    
    def logit
      url = params[:url]
      url.strip!
      if not (url =~ /http\:\/\//i)
          url = "http://"+url
      end
      _uri =URI.parse(url)
      uri =  URI.split(esc(url));
      url =~ /.*?:\/\/.*\//m
      context = $&
      
    begin
      res = getPage(url, 10, nil, nil)
      print "------->inspect:"+res.inspect+"\n"
         content = res.body
           
      rescue Exception=>e
        print "=====>exception:#{e}\n"
        content = "Cannot get page"
    end
      # get charset
      #p "==>content=#{content}"
    if (content =~/<meta.*?charset=[\'\"]*([-\w\d]+)[\'\"]*.*?>/mi)
      encode = $1.gsub(" ", "")
    else
      encode = "utf-8"
    end
      logger.info  "---->charset="+encode+"\n"
      p "=====>charset=#{encode}"
      if  not (encode =~ /~utf-8$/i)
begin
  p "===>convert charset\n"
  if (encode =~ /gb2312/i)
      encode="GBK"
  end
  
        content = Iconv.conv('utf-8//IGNORE', encode+"//IGNORE", content)
         p "===>converted charset successfully\n"
rescue Exception=>e
	logger.info "===>exception:#{e.inspect}\n"
	p "===>exception:#{e}\n"
	p "===>content2=#{content}\n"
	title = getTitle (content)
	if (title)
		begin
			title = Iconv.conv('utf-8', encode, title)
		rescue Exception=>ee
			logger.info "===exception:#{e}\n"
			p "===>exception:#{e}\n"
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
       
       #only get content within body tag
      content_re = /<body(.*?)>(.*)<\/body>/xmi
      m = content_re.match(content)     
      if m
         print "\n---------->m:#{m}\n"
       print "\n---------->m1:#{m[1]}\n"
        print "\n---------->m2:#{m[2]}\n"
      content = "<div id='body123' #{m[1]}>#{m[2]}<\/div>"
     end
      print "\n---------->content1:#{content}"
      
      # remove js from content
     content = content.gsub(/<script(.*?)<\/script>/mi, "")
   
     # fix img (add host if img/src doesn't have, to make it easy for downloading afterwards)
     # add host before "/"
     content = content.gsub(/(<img.*?src=[\"\'])\//){|m| "#{$1}#{uri[0]}:\/\/#{uri[2]}\/"}
     # add context path if no "/"
     content = content.gsub(/(<img.*?src=[\"\'])([^\/(http:\/\/)])/){|m| "#{$1}#{context}#{$2}"}
     #  print "\n---------->content:#{content}"
     
  
      # add one link to original page
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

    # download img and change src  
    FileUtils.makedirs("public/imgdb/#{docid}")
    img_index = 0

    content = content.gsub(/(<img.*?src=[\"\'])(.*?)([\"\'])/i){|m|
     p "==>2"+$2
     c = $2
     begin
         fimg=download_img(_uri, docid, $2, img_index)
          img_index = img_index+1
          c = "http://#{ENV['server_name']}:#{ENV['port']}/imgdb/#{docid}/#{fimg}"

     rescue Exception=>e
         p "===>exception:#{e.inspect}"
     end
         "#{$1}#{c}#{$3}"
    }
  
    # download img for background
    content = content.gsub(/(body)(.*?{.*?background:.*?url\()(.*?)(\))/i){|m|
     p "==>22"+$3
     c = $3
     begin
         fimg=download_img(_uri, docid, $3, img_index)
        img_index = img_index+1
        c = "http://#{ENV['server_name']}:#{ENV['port']}/imgdb/#{docid}/#{fimg}"
    rescue Exception=>e
        p "===>exception:#{e.inspect}"
     end
     "div\#body123#{$2}#{c}#{$4}"
    }
  
     
      doc[:content] = content
      save_doc(doc)
      redirect_to :action=>'index', :docid=>docid

    end
    
    def download_img(uri, docid, url, index)
       
        if not (url=~/http\:\/\//i)
            if url =~/~\//i
                 url = "#{uri.scheme}://#{uri.host}:#{uri.port}#{url}"
            else
                 url = "#{uri.scheme}://#{uri.host}:#{uri.port}#{uri.path}/#{url}"
            end
        end
        url =   URI.escape(url)
           target_uri = URI.parse(url)
           p "==>downloading #{target_uri.host},#{target_uri.path},#{target_uri.query}"
           Net::HTTP.start(target_uri.host) { |http|
        if (target_uri.query and target_uri.query.length>0)
            resp = http.get("#{target_uri.path}?#{target_uri.query}")
        else
            resp = http.get("#{target_uri.path}")
        end
        
 
         resp['Content-Type']=~ /image\/(.*)$/i
         p "===> downloaded img #{url} to #{index}.#{$1}, content-type=#{resp['Content-Type']}" 
         open("public/imgdb/#{docid}/#{index}.#{$1}", "wb") { |file|
             file.write(resp.body)
         }
         return "#{index}.#{$1}"
     }
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
      r = -1
      begin 
        r = Publish.pub_by_mwl(current_user, docid, username, pwd, url)
      rescue Exception=>e
        render :text=>"<script>showErrDlg('#{e.message}')</script>"
      end
      
      if r < 0
          render :text=>"Publish failed"
      elsif r == 0
          render :text=>"日志发布成功"
      elsif r == 1
          render :text=>"Update blog succeeded."
      end
      
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
