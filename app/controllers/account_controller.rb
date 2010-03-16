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
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
     # redirect_back_or_default(:controller => '/account', :action => 'index')
     redirect_back_or_default(:controller => '/editor', :action => 'index')
      flash[:notice] = "Logged in successfully"
    end
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
end
