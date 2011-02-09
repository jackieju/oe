class UserinfosController < ApplicationController
  # GET /userinfos
  # GET /userinfos.xml
  def index
    @userinfos = Userinfo.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @userinfos }
    end
  end

  # GET /userinfos/1
  # GET /userinfos/1.xml
  def show
    @userinfo = Userinfo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @userinfo }
    end
  end

  # GET /userinfos/new
  # GET /userinfos/new.xml
  def new
    @userinfo = Userinfo.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @userinfo }
    end
  end

  # GET /userinfos/1/edit
  def edit
    @userinfo = Userinfo.find(params[:id])
  end

  # POST /userinfos
  # POST /userinfos.xml
  def create
    @userinfo = Userinfo.new(params[:userinfo])

    respond_to do |format|
      if @userinfo.save
        flash[:notice] = 'Userinfo was successfully created.'
        format.html { redirect_to(@userinfo) }
        format.xml  { render :xml => @userinfo, :status => :created, :location => @userinfo }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @userinfo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /userinfos/1
  # PUT /userinfos/1.xml
  def update
    @userinfo = Userinfo.find(params[:id])

    respond_to do |format|
      if @userinfo.update_attributes(params[:userinfo])
        flash[:notice] = 'Userinfo was successfully updated.'
        format.html { redirect_to(@userinfo) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @userinfo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /userinfos/1
  # DELETE /userinfos/1.xml
  def destroy
    @userinfo = Userinfo.find(params[:id])
    @userinfo.destroy

    respond_to do |format|
      format.html { redirect_to(userinfos_url) }
      format.xml  { head :ok }
    end
  end
end
