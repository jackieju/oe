require 'net/smtp'
require 'iconv'
require 'metaweblogapi'



class EditorController < ApplicationController

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

  end
