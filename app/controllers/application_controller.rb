# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require "openappserver"

class ApplicationController < ActionController::Base

 # include AuthenticatedSystem
  include OpenAppServer
  helper :all # include all helpers, all the time
  #protect_from_forgery # See ActionController::RequestForgeryProtection for details
  def error(msg, data=nil)
       ret = {
          "error"=>msg
      }
      ret = ret.merge(data) if data
      render :text=>ret.to_json
      # render :text=>"{\"error\":\"#{msg}\"}"
  end
  def success(msg="OK", data=nil)
      ret = {
          "OK"=>msg
      }
      ret = ret.merge(data) if data
      render :text=>ret.to_json
  end

  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
