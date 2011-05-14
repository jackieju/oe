class OauthController < ApplicationController
     include AuthenticatedSystem
    def index
             p "index !!\n"
       # Publish.pub_to_csdn(current_user, 0, "fdsf","")
     #   @request_token = Publish.pub_to_tsina(current_user, 0)
              @callback_url = "http://oe:3000"
               #@callback_url = "http://www.google.com"
           @consumer = OAuth::Consumer.new("3983375741","de7f642798c4b05d7c2bb143c5d2ad6a", :site => "http://api.t.sina.com.cn/oauth/request_token")
          @request_token = @consumer.get_request_token(:oauth_callback => @callback_url)
         session[:request_token] = @request_token
     #         render :text=>"index !!\n"
     redirect_to @request_token.authorize_url(:oauth_callback => @callback_url)
    end
    def callback_tsina
         @request_token = session[:request_token] 
        p "callback_tsina !!\n"
        if (! @request_token )
            p "authentication failed\n"
             render :text=>"authentication failed, r_token=#{@request_token}!!\n"
        else
            @access_token = @request_token.get_access_token
               render :text=>"callback_tsina a_token=#{@access_token}!!\n"
        end
          
#  @photos = @access_token.get('/photos.xml')
   
    end
end
