class PubsetsController < ApplicationController
  include AuthenticatedSystem
  def index
    ui = Userinfo.find_by_sql("select * from userinfos where uid=#{current_user[:id]}")
     @list=[]
         logger.debug "----------->#{@list.size}"
    if (ui && ui.size>0 && ui[0][:blogset])
      jsons = ui[0][:blogset].split(";#;")
      for j in jsons do
        json =  ActiveSupport::JSON.decode(j)
        logger.debug "json=#{json}"
        
        @list.push(json) if json
      end
    end
    render :layout=>false
  end
  
  def update_bs
   json = params[:json]
   logger.debug "json=#{json}"
   ui = Userinfo.find_by_sql("select * from userinfos where uid=#{current_user[:id]}")
   if (ui && ui.size>0)
     _ui = ui[0]
   else
     _ui = Userinfo.new(
     {
       :uid=>current_user[:id]
     }
     )
   end
     _ui["blogset"] = json
     _ui.save!
      render :layout=>false, :text=>"ok"
  end
  
  def pub_all
    docid = params[:docid]
    json = params[:json]
    logger.debug "json=#{json}"
    ui = Userinfo.find_by_sql("select * from userinfos where uid=#{current_user[:id]}")
    if (ui && ui.size>0)
       _ui = ui[0]
    else
       _ui = Userinfo.new({
         :uid=>current_user[:id]
       })
     end
    _ui["blogset"] = json
    _ui.save!
    
    json_array = json.split(";#;")
    logger.debug "\n===>"+json_array.join("\n===>")
    
    msg = ""
    r  = 0
    for j in json_array do
      blog = ActiveSupport::JSON.decode(j)
      if blog['blog_auto'] == "false"
        next
      end
      begin
        msg = msg + "\n向#{blog['blog_name']}发布日志:\n"
        logger.debug "--->#{blog['blog_type']}"
        if (blog['blog_type'] == "email")
          Publish.email_doc(current_user, docid, blog['blog_emailf'], blog['blog_emailt'])
        elsif (blog['blog_type'] == "metaweblog")
          rc =Publish.pub_by_mwl(current_user, docid, blog['blog_username'], blog['blog_pwd'], blog['blog_url'])
          if rc == 0
              msg=msg+"创建新日志"
          elsif rc ==1
            msg = msg + "更新日志"
            end
        else
          raise "unkown blog type"
        end
         msg = msg + "成功\n"
         r = r+1
      rescue Exception=>e
        msg = msg + e.message + ":"+e.backtrace.join("\n")
      end
      

    end
           msg = msg + "\n#{r}个blog发布成功\n"

    render :text=>msg
  end
=begin
  # GET /pubsets
  # GET /pubsets.xml
  def index
    @pubsets = Pubset.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pubsets }
    end
  end

  # GET /pubsets/1
  # GET /pubsets/1.xml
  def show
    @pubset = Pubset.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pubset }
    end
  end

  # GET /pubsets/new
  # GET /pubsets/new.xml
  def new
    @pubset = Pubset.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pubset }
    end
  end

  # GET /pubsets/1/edit
  def edit
    @pubset = Pubset.find(params[:id])
  end

  # POST /pubsets
  # POST /pubsets.xml
  def create
    @pubset = Pubset.new(params[:pubset])

    respond_to do |format|
      if @pubset.save
        flash[:notice] = 'Pubset was successfully created.'
        format.html { redirect_to(@pubset) }
        format.xml  { render :xml => @pubset, :status => :created, :location => @pubset }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @pubset.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pubsets/1
  # PUT /pubsets/1.xml
  def update
    @pubset = Pubset.find(params[:id])

    respond_to do |format|
      if @pubset.update_attributes(params[:pubset])
        flash[:notice] = 'Pubset was successfully updated.'
        format.html { redirect_to(@pubset) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pubset.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pubsets/1
  # DELETE /pubsets/1.xml
  def destroy
    @pubset = Pubset.find(params[:id])
    @pubset.destroy

    respond_to do |format|
      format.html { redirect_to(pubsets_url) }
      format.xml  { head :ok }
    end
  end
=end
end
