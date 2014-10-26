class PersonApi < ActionWebService::API::Base  
  inflect_names false  
  api_method :add, :expects => [:string], :returns => [:int]  
  api_method :remove, :expects => [:int], :returns => [:bool]  
end  