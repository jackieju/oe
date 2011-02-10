class UserappsController < ApplicationController
  # GET /userapps
  # GET /userapps.xml
  def index
    @userapps = Userapp.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @userapps }
    end
  end

  # GET /userapps/1
  # GET /userapps/1.xml
  def show
    @userapp = Userapp.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @userapp }
    end
  end

  # GET /userapps/new
  # GET /userapps/new.xml
  def new
    @userapp = Userapp.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @userapp }
    end
  end

  # GET /userapps/1/edit
  def edit
    @userapp = Userapp.find(params[:id])
  end

  # POST /userapps
  # POST /userapps.xml
  def create
    @userapp = Userapp.new(params[:userapp])

    respond_to do |format|
      if @userapp.save
        flash[:notice] = 'Userapp was successfully created.'
        format.html { redirect_to(@userapp) }
        format.xml  { render :xml => @userapp, :status => :created, :location => @userapp }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @userapp.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /userapps/1
  # PUT /userapps/1.xml
  def update
    @userapp = Userapp.find(params[:id])

    respond_to do |format|
      if @userapp.update_attributes(params[:userapp])
        flash[:notice] = 'Userapp was successfully updated.'
        format.html { redirect_to(@userapp) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @userapp.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /userapps/1
  # DELETE /userapps/1.xml
  def destroy
    @userapp = Userapp.find(params[:id])
    @userapp.destroy

    respond_to do |format|
      format.html { redirect_to(userapps_url) }
      format.xml  { head :ok }
    end
  end
end
