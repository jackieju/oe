require 'oauth'
class OauthController < ApplicationController
     include AuthenticatedSystem
    def index
             p "index !!\n"
       # Publish.pub_to_csdn(current_user, 0, "fdsf","")
     #   @request_token = Publish.pub_to_tsina(current_user, 0)
              @callback_url = "http://#{ENV['server_name']}:#{ENV['port']}/oauth/callback_tsina?docid=#{params[:docid]}"
            #@callback_url = "http://oe:3000/oauth/callback_tsina?docid=#{params[:docid]}"
               #@callback_url = "http://www.google.com"
           @consumer = OAuth::Consumer.new("3983375741","de7f642798c4b05d7c2bb143c5d2ad6a", :site => "http://api.t.sina.com.cn")
          @request_token = @consumer.get_request_token(:oauth_callback => @callback_url)
    
        # session[:request_token] = @request_token
        session[:request_token] = @request_token.token
        session[:request_token_secret] = @request_token.secret

     #         render :text=>"index !!\n"
     redirect_to @request_token.authorize_url(:oauth_callback => @callback_url)
    end
    def callback_tsina
        doc = Doc.find(params[:docid])
        t = doc[:title]
        if t.length > 100
            t = t[0..99]
        end

        # post doc title with a link to blog content
        #content = "#{t} http://oe.ns-soft.com/docs/#{params[:docid]}" 
        day = Time.now() 
        sday = day.strftime("%Y/%m/%d")
        s_title = t.gsub(" ", "-")
        content = "#{t} http://jackiejuju.wordpress.com/#{sday}/#{s_title}/"  
           p "===>content=#{content}"
     #    @request_token = session[:request_token] 
        @consumer = OAuth::Consumer.new("3983375741","de7f642798c4b05d7c2bb143c5d2ad6a", :site => "http://api.t.sina.com.cn")
     @request_token = OAuth::RequestToken.new( @consumer, session[:request_token], session[:request_token_secret] ) 
        p "callback_tsina #{params}!!\n"
        if (! @request_token )
            p "authentication failed\n"
             render :text=>"authentication failed, r_token=#{@request_token}!!\n"
        else
             p "authentication  r_token=#{@request_token}\n"
            @access_token = @request_token.get_access_token(:oauth_verifier=>params["oauth_verifier"])
   #         session[:access_token] = @access_token
            r = @access_token.post('/statuses/update.xml', {:source=>'3983375741', :status=>content})
            p "==>#{r.body}"
=begin 
            _params = {
                :method => method,
                :api_key => @api_key,
                :session_key => @session_key,
                :call_id => Time.now.to_i,
                :v => "1.0" }
            _params.merge!(params) if params
            
            Net::HTTP.post_form(url, _params)
=end
        #    render :text=>"callback_tsina a_token=#{@access_token}!!\n"
        flash[:notice] = "Publish to t.sina.com.cn succeeded."
        redirect_to "/editor/index?docid=#{params[:docid]}"
        end
          
#  @photos = @access_token.get('/photos.xml')
   
    end
end
