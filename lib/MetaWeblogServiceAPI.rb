require "actionwebservice"
class MetaWeblogServiceAPI< ActionWebService::API::Base
inflect_names false  
  api_method :newPost, :expects => [:string], :returns => [:int]  
  api_method :remove, :expects => [:int], :returns => [:bool]  
  api_method :test, :expects => [], :returns => [:int]  
end