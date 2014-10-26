require "MetaWeblogServiceAPI.rb"
class MetaWeblogService < ActionWebService::Base
      web_service_api MetaWeblogServiceAPI
      def newPost
          p  "===>newPost->#{params}"
      end
      
      def remove
      end
      
      def test
            p  "===>test->#{params}"
            return 1
      end
end