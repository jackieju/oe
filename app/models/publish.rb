require 'net/smtp'
require 'iconv'
require 'oauth'
class Publish < ActiveRecord::Base
  
  
  class << self
      def send_email(current_user, from, from_alias, to, to_alias, subject, message, docid)
 publish_target_list = Publish.find_by_sql("select id,target,permalink from publishes where docid=#{docid} group by target")
      ptl=""
       #print "====>2="+publish_target_list[1][:target]+"\n"
       if publish_target_list
      for r in (0..publish_target_list.size-1) do
        print "===>112#{publish_target_list[r][:target].to_s}"
        ptl += "<a href=\"#{publish_target_list[r][:permalink].to_s}\" >#{publish_target_list[r][:target].to_s} </a><br>"
      end
    end

		sg = ""
		if docid
	if (publish_target_list && publish_target_list.size>0)
       doc = Doc.find(docid)
        type= "文"
        type = "网摘" if doc[:doctype] == 2

         sg ="
       <div style=\"margin-left:68%;backgroud:transparent;\">
       该#{type}已同时发布到<br>
       #{ptl}
       </div>"
       end
	
		end
		footer = "<br><div class='code' style=\"background:#ffddcc;text-align:right;\">This article is created by <a href=\"http://#{ENV['server_name']}\" >开心写作网</a>#{sg}</div>"

        #	msg = "#{message}"
        _sub = Base64.b64encode(subject).gsub("\n","").gsub("\r","")
        logger.info("subject:#{_sub};")
        msg = <<MESSAGE_END
From: #{from_alias} <#{from}>
To: #{to_alias} <#{to}>
MIME-Version: 1.0
Content-type: text/html;charset=utf-8
Subject:=?UTF-8?B?#{_sub.rstrip}?=

#{message}
#{footer}
MESSAGE_END

        #	m =	Iconv.conv('utf-8', 'iso-8859-1', msg)
        logger.info(msg)

        Net::SMTP.start('localhost') do |smtp|
          smtp.send_message msg, from, to
        end

host = to.sub(/.*@/, "")
Publish.new({
           :uid=>current_user[:id],
           :username=>current_user.login,
           :docid=>docid,
           :target=>host,
           :doctitle=>subject,
           :permalink=>""
         }).save!

      end

      def pub_to_tsina(current_user, docid)
           @callback_url = "http://127.0.0.1:3000/oauth/callback_tsina"
           @consumer = OAuth::Consumer.new("3983375741","de7f642798c4b05d7c2bb143c5d2ad6a", :site => "http://api.t.sina.com.cn/oauth/request_token")
          @request_token = @consumer.get_request_token(:oauth_callback => @callback_url)
      #    session[:request_token] = @request_token
      #    redirect_to @request_token.authorize_url(:oauth_callback => @callback_url)
          return @request_token
      end
  def pub_to_csdn(current_user, docid, username, pwd)
         client = MetaWebLogAPI::Client.new('blog.csdn.net', "/#{username}/services/MetaBlogApi.aspx", '1', username, pwd)
          begin
          bloginfo = client.getUsersBlogs()
         rescue Exception=>e
            trace = e.backtrace.join("\n")
            #render :text=>"<script>showErrDlg('#{e}, #{e.message}')</script>"
            raise "#{e}, #{e.message}, #{trace}"
            return
          end
          logger.info("getUsersBlogs:#{bloginfo}, "+bloginfo[0]['blogid'])
          client = MetaWebLogAPI::Client.new('blog.csdn.net', "/#{username}/services/MetaBlogApi.aspx", bloginfo[0]['blogid'], username, pwd)

          logger.info("usernmae:#{username};")
          logger.info("password:#{pwd};")
          logger.info("url:/#{username}/services/MetaBlogApi.aspx")
          sg = "<br><div class='code' style='background:#ffddcc;text-align:right;'>This article is created by <a href='http://#{ENV['server_name']}' >开心写作网</a></div>"
          blogpost = {
            'title' => @doc[:title],
            'description' => @doc[:content]+sg,
            'pubDate' => Time.now
          }
          begin
            rsp = client.newPost(blogpost, true)
            logger.debug "===>postid:#{rsp}"
            rsp = client.getPost(rsp);
             logger.debug "===>getPost:#{rsp}"
             permalink = rsp['permalink']
             logger.debug "===>permalink:#{permalink}"
          rescue Exception=>e
            trace = e.backtrace.join("\n")
           # render :text=>"<script>showErrDlg('#{e}, #{e.message}, #{trace}')</script>"
           raise "#{e}, #{e.message}, #{trace}"
            return
          end

          Publish.new({
            :uid=>current_user[:id],
            :username=>current_user.login,
            :docid=>docid,
            :target=>"CSDN",
            :doctitle=>@doc[:title],
             :permalink=>permalink
          }).save!

         # render :text=>"日志发布成功"
          return
  end
  
  def pub_by_mwl(current_user, docid, username, pwd, url)
  
     if !url
       url = ""
     else
       url = url.rstrip.strip
     end
  
     begin
       @doc = Doc.find(docid);
       @doc[:content] = @doc.loadContent()
     rescue RuntimeError=>e 
       logger.info e
      # render :text=>  "<script>showErrDlg('文章不存在')</script>"
      raise "文章不存在"
       return
     end
   
       permalink = ''
       logger.info("url:#{url}")
       match_result = url.match("^http://(.*?)/(.*)")
       if (!match_result)
         #render :text=>"<script>showErrDlg('url不正确')</script>"
         raise "url不正确"
         return
       end
       host = match_result[1]
       path = "/"+match_result[2]
       
       if (host == "blog.csdn.net")
          pub_to_csdn(current_user, docid, username, pwd)
          return
       end
       
		doc = Doc.find(docid)
		type= "文"
		type = "网摘" if doc[:doctype] == 2

       client = MetaWebLogAPI::Client.new(host, path, '11', username, pwd)
       logger.info("host:#{host}, path:#{path}")
      publish_target_list = Publish.find_by_sql("select id,target,permalink from publishes where docid=#{docid} group by target")
      ptl=""
       #print "====>2="+publish_target_list[1][:target]+"\n"
       if publish_target_list 
      for r in (0..publish_target_list.size-1) do
        print "===>112#{publish_target_list[r][:target].to_s}"
        ptl += "<a href=\"#{publish_target_list[r][:permalink].to_s}\" >#{publish_target_list[r][:target].to_s} </a><br>"
      end
    end
       sg = "<br>
       <div class='code' style='background:#ffddcc;text-align:right;'>This article is created by <a href='http://#{ENV['server_name']}' >开心写作网</a>"
       
       if (publish_target_list && publish_target_list.size>0)
         sg +="
       <div style=\"margin-left:68%;backgroud:transparent;\">
       该#{type}已同时发布到<br>
       #{ptl}
       </div>"
       end
       sg +="
       </div>
       "
       blogpost = {
         'title' => @doc[:title],
         'description' => @doc[:content]+sg,
         'pubDate' => Time.now
       }
       postid = ""
       # try to get post id from pubish history
       postids = Publish.find_by_sql("select postid from publishes where docid=#{docid} and uid='#{current_user[:id]}' and target='#{host}'order by updated_at desc limit 10")
      # p "===>select postid from publishes where docid=#{docid} and uid='#{current_user[:id]}'"
       p "\n===>postids=#{postids}\n"
       if (postids)
           for pid in postids
               if (pid != "" && pid[:postid]!="")
                   postid=pid[:postid]
                   p "#{pid[:postid]}"
                   break
                end
           end
       end
       type =  -1
       if (postid == "") # new post
           type =0
           begin
             rsp = client.newPost(blogpost, true)
                  postid = rsp.to_s
             logger.debug "===>postid:#{rsp}"
              rsp = client.getPost(rsp);
                logger.debug "===>getPost:#{rsp}"
                permalink = rsp['permaLink']
                if (!permalink || permalink.size==0)
                   permalink = rsp['permalink']
                end
                logger.debug "===>permalink:#{permalink}"
            
           rescue Exception=>e
             trace = e.backtrace.join("\n")
             logger.error ("#{e}, #{e.message}, #{trace}")
             #render :text=>"<script>showErrDlg('#{e}, #{e.message}, #{trace}')</script>"
             raise "#{e}, #{e.message}, #{trace}"
          #render :text=>"error"
             return
           end
       else  # upate existing post
           type = 1
           begin 
               p "===>post id: #{postid}"
               rsp = client.editPost(postid, blogpost, true)
                logger.debug "===>editpost return:#{rsp}"
                rsp = client.getPost(postid);
                logger.debug "===>getPost:#{postid}"
                permalink = rsp['permaLink']
                if (!permalink || permalink.size==0)
                   permalink = rsp['permalink']
                end
                logger.debug "===>permalink:#{permalink}"
           rescue Exception=>e
             trace = e.backtrace.join("\n")
             logger.error ("#{e}, #{e.message}, #{trace}")
             raise "#{e}, #{e.message}, #{trace}"
             return
           end  
       end # if (postid == "")
         
   
        Publish.new({
           :uid=>current_user[:id],
           :username=>current_user.login,
           :docid=>docid,
           :target=>host,
           :doctitle=>@doc[:title],
           :permalink=>permalink,
           :postid =>postid 
         }).save!

       #render :text=>"日志发布成功"
       return type
  end
  
  def email_doc(current_user, docid, from, to)
     @doc = Doc.find(docid)
     save_email(current_user[:id],from, to)
     @doc[:content] = @doc.loadContent()
     begin
       Publish.send_email(current_user,from, current_user.login, to, to, @doc[:title], @doc[:content], docid)
     rescue Exception=>e
      # render :text=>"<script>showErrDlg('Email发送失败')</script>"
      logger.error e.inspect
       raise "Email发送失败"
       return
     end
  
  end


  
  # save email address for autocomplete
  def save_email(uid, from, to)
    userinfo = nil
    userinfos = Userinfo.find_by_sql("select * from userinfos where uid=#{uid}")
    if (!userinfos || userinfos.size==0)
      userinfo = Userinfo.new({:uid=>uid});
      userinfo[:prop] = ""
    else
      userinfo = userinfos[0]
       userinfo[:prop] = "" if ! userinfo[:prop] 
    end

    propJson =       ActiveSupport::JSON.decode(userinfo[:prop])
    logger.info "====>#{propJson}"
    if (!propJson)
      propJson={}
    end

    j_from = (propJson["email_from"])?propJson["email_from"]:""
    j_to = (propJson["email_to"])?propJson["email_to"]:""
    logger.info("j_from:#{j_from}, j_to:#{j_to}")
    if (from && from.size>0)
      if (!j_from.match(from+";"))
        j_from += from+";"
        propJson["email_from"] = j_from
      end
    end
    if (to && to.size>0)
      if (!j_to.match(to+";"))
        j_to += to+";"
        propJson["email_to"] = j_to
      end
    end
    userinfo[:prop] = ActiveSupport::JSON.encode(propJson)
    userinfo.save!
  end
  
  end
end
