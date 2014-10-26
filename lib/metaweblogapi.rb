require 'xmlrpc/client'

module MetaWebLogAPI
  class Client
    def initialize(server, urlPath, blogid, username, password)
      @client = XMLRPC::Client.new(server, urlPath)
      @blogid = blogid
      @username = username
      @password = password
    end
   
	def getUsersBlogs
		@client.call('blogger.getUsersBlogs', 'appkey', @username,
          @password)
	end
	
    def newPost(content, publish)
    # p "===>test xmlrpc:"+@client.call('metaWeblog.test')
      
       @client.call('metaWeblog.newPost', @blogid, @username,
          @password, content, publish)

    end

    def getPost(postid)
      @client.call('metaWeblog.getPost', postid, @username,
          @password)
    end

    def editPost(postid, content, publish)
      @client.call('metaWeblog.editPost', postid, @username,
          @password, content, publish)
    end
  end
end
