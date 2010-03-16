require 'metaweblogapi'

class PublishesController < ApplicationController
  # GET /publishes
  # GET /publishes.xml
  
  def list
    @page_size = 20
    @uid = params[:uid]
    r = nil
    if (!@uid || @uid.size==0)  
      r = ActiveRecord::Base.connection.execute("select count(*) from publishes")
    else
      r = ActiveRecord::Base.connection.execute("select count(*) from publishes where uid=#{@uid}")
    end
    rr = r.fetch_row[0].to_i
    @page_number = rr / @page_size
    if (@page_number *  @page_size != rr )
      @page_number = @page_number +1
    end


    @current_page = params[:page]
    if (!@current_page)
      @current_page = 1
    else 
      @current_page = @current_page.to_i
    end
    @current_page = 1 if  @current_page == 0
    current_page =  @current_page -1 

    start = @page_size*current_page
    number = @page_size
    if (!@uid || @uid.size==0)  
      @list = Publish.find_by_sql("select * from publishes order by created_at desc  limit #{start},#{number} ") 
    else
      @list = Publish.find_by_sql("select * from publishes where uid=#{@uid} order by created_at desc  limit #{start},#{number} ")    
    end   
    logger.info(">>>>>>>>>>>>>>>>>doclist=#{@doc_list}")

    render :layout=>false
    
  end
  
  def index
    @publishes = Publish.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @publishes }
    end
  end

  # GET /publishes/1
  # GET /publishes/1.xml
  def show
    @publish = Publish.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @publish }
    end
  end

  # GET /publishes/new
  # GET /publishes/new.xml
  def new
    @publish = Publish.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @publish }
    end
  end

  # GET /publishes/1/edit
  def edit
    @publish = Publish.find(params[:id])
  end

  # POST /publishes
  # POST /publishes.xml
  def create
    @publish = Publish.new(params[:publish])

    respond_to do |format|
      if @publish.save
        flash[:notice] = 'Publish was successfully created.'
        format.html { redirect_to(@publish) }
        format.xml  { render :xml => @publish, :status => :created, :location => @publish }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @publish.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /publishes/1
  # PUT /publishes/1.xml
  def update
    @publish = Publish.find(params[:id])

    respond_to do |format|
      if @publish.update_attributes(params[:publish])
        flash[:notice] = 'Publish was successfully updated.'
        format.html { redirect_to(@publish) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @publish.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /publishes/1
  # DELETE /publishes/1.xml
  def destroy
    @publish = Publish.find(params[:id])
    @publish.destroy

    respond_to do |format|
      format.html { redirect_to(publishes_url) }
      format.xml  { head :ok }
    end
  end
end
