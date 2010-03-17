class AccountController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie

  # say something nice, you goof!  something sweet.
  def index
    redirect_to(:action => 'signup') unless logged_in? || User.count > 0
    redirect_back_or_default(:controller => '/editor', :action => 'index')
  end

  def login
    return unless request.post?
=begin
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
=end
    if using_open_id?
      open_id_authentication(params[:openid_url])
    elsif params[:login]
      password_authentication(params[:login], params[:password])
    end
     # redirect_back_or_default(:controller => '/account', :action => 'index')
   #  redirect_back_or_default(:controller => '/editor', :action => 'index')
   #   flash[:notice] = "Logged in successfully"
  end

 def password_authentication(login, password)
        if self.current_user = User.authenticate(params[:login], params[:password])
          print "\n--->successful_login with #{self.current_user.login}\n"
          successful_login
        else
          failed_login("Invalid login or password")
        end
      end
       def open_id_authentication(openid_url)
        print "\n--->openid_url:  #{openid_url}; #{params['openid.identity']}\n"
            authenticate_with_open_id openid_url, :required => [:nickname, :email] do |result, identity_url, registration|     
              print "\n--->openid_url2:  #{openid_url}\n"
              print "\n--->result:#{result.status}\n"
              if result.successful?
                @user = self.current_user = User.find_or_create_by_identity_url(identity_url)
              
              print "\n====>get_extension_args=#{registration.get_extension_args}"  
                print "\n----->registration[nickname]=#{registration['nickname']}\n" if defined?registration['nickname']
               
                print "\n----->registration[email]=#{registration['email']}\n" if defined?registration['email']
             
                print "\n----->registration[login]=#{registration['login']}\n" if (defined?registration['login']&&registration['login'])
             print "\n----->registration[login]=#{registration['fullname']}\n" if (defined?registration['fullname']&&registration['fullname'])
             print "\n----->registration[login]=#{registration['display_name']}\n" if (defined?registration['display_name']&&registration['display_name'])
           
                print "\n---->current_user['login']=#{ params['openid.identity']}\n"
                if self.current_user['login']
                   print "\n----->current_user login defined:#{self.current_user['login']}\n"
                end
               # if (!defined?registration['login']||!registration['login']) && !self.current_user['login'] && params['openid.identity']
               if  !self.current_user['login'] 
                   print "\n--->openid_url1:  #{openid_url}\n"
                   print "\n--->uid:  #{self.current_user.id}\n"
                   if (params['openid.identity'])
                      self.current_user['login']= params['openid.identity']
                  else
                     self.current_user['login'] = self.current_user.id;
                  end
                  self.current_user.save
                end
                if @user.new_record?
                  print "\n------->new record\n"
                  # registration is a hash containing the valid sreg keys given above
                  # use this to map them to fields of your user model
                  {'login=' => 'nickname', 'email=' => 'email'}.each do |attr, reg|
                    current_user.send(attr, registration[reg]) unless registration[reg].blank?
                  end
 
                  if @user.valid?
                    @user.save
                    self.current_user = @user
                    print "\n--->successful_login with #{self.current_user.login}\n"
                    successful_login
                  else
                    failed_login "Authentication failed on this website."
                  end
                else
                  self.current_user = @user
                  successful_login
                end

              else
                failed_login result.message
              end
            end
              print "\n--->openid_url3:  #{openid_url}\n"
          end

      
  def signup
    @user = User.new(params[:user])
    return unless request.post?
    @user.save!
    Memo.new({:content=>"this is a memo",:uid=>@user[:id], :position=>"{left: 32, top: 181, width: 215, height: 89}"}).save
     Memo.new({:content=>"this is a memo",:uid=>@user[:id], :position=>"{left: 44, top: 255, width: 215, height: 89}"}).save
     Memo.new({:content=>"this is a memo",:uid=>@user[:id], :position=>"{left: 44, top: 255, width: 215, height: 89}"}).save
     Memo.new({:content=>"this is a memo",:uid=>@user[:id], :position=>"{left: 289, top: 146, width: 215, height: 89}"}).save
     Memo.new({:content=>"this is a memo",:uid=>@user[:id], :position=>"{left: 390, top: 241, width: 700, height: 213}"}).save
     Memo.new({:content=>"this is a memo",:uid=>@user[:id], :position=>"{left: 31, top: 103, width: 215, height: 89}"}).save
      Memo.new({:content=>"this is a memo",:uid=>@user[:id], :position=>"{left: 952, top: 3, width: 200, height: 300}"}).save
      Memo.new({:content=>"this is a memo",:uid=>@user[:id], :position=>"{left: 843, top: 109, width: 200, height: 300}"}).save
    self.current_user = @user
    redirect_back_or_default(:controller => '/account', :action => 'index')
    flash[:notice] = "Thanks for signing up!"
  rescue ActiveRecord::RecordInvalid
    render :action => 'signup'
  end
  
  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(:controller => '/account', :action => 'login')
  end
    private
      def successful_login
        
        session[:user_id] = @current_user.id
        #redirect_back_or_default({:action => :show})
        redirect_back_or_default(:controller => '/editor', :action => 'home')
        flash[:notice] = "Logged in successfully"
      end

      def failed_login(message)
        redirect_to(:action => 'login')
        flash[:warning] = message
      end
end
