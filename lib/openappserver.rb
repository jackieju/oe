module OpenAppServer
  protected
      # Inclusion hook to make #current_user and #logged_in?
    # available as ActionView helper methods.
 def self.included(base)
      base.send :helper_method, :getAppList, :apps
 end
 
 def getAppList(userid)
  # print current_uesr.id
  if !@apps
    @apps =  Userapp.find_by_sql("select * from userapps where uid=#{userid}")
  end
  return @apps
 end
 
 def init_apps(userid)
  @apps = getAppList(userid)
 end
 
 def apps
  # getAppList(current_user.id)
   return @apps
 end
 
 private
end
