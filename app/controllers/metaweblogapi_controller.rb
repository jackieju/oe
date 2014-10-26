require "MetaWeblogService.rb"
require "MetaWeblogServiceAPI.rb"
class MetaweblogapiController < ApplicationController
    web_service_dispatching_mode :layered
  
   # web_service :mt, MovableTypeService.new
  #  web_service :blogger, BloggerService.new
    web_service :metaWeblog, MetaWeblogService.new
    #web_service_api PersonApi
     

  

end
