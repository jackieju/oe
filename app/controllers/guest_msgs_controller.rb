class GuestMsgsController < ApplicationController
  # GET /guest_msgs
  # GET /guest_msgs.xml
  def index
    @guest_msgs = GuestMsg.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @guest_msgs }
    end
  end

  # GET /guest_msgs/1
  # GET /guest_msgs/1.xml
  def show
    @guest_msg = GuestMsg.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @guest_msg }
    end
  end

  # GET /guest_msgs/new
  # GET /guest_msgs/new.xml
  def new
    @guest_msg = GuestMsg.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @guest_msg }
    end
  end

  # GET /guest_msgs/1/edit
  def edit
    @guest_msg = GuestMsg.find(params[:id])
  end

  # POST /guest_msgs
  # POST /guest_msgs.xml
  def create
    @guest_msg = GuestMsg.new(params[:guest_msg])

    respond_to do |format|
      if @guest_msg.save
        flash[:notice] = 'GuestMsg was successfully created.'
        format.html { redirect_to(@guest_msg) }
        format.xml  { render :xml => @guest_msg, :status => :created, :location => @guest_msg }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @guest_msg.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /guest_msgs/1
  # PUT /guest_msgs/1.xml
  def update
    @guest_msg = GuestMsg.find(params[:id])

    respond_to do |format|
      if @guest_msg.update_attributes(params[:guest_msg])
        flash[:notice] = 'GuestMsg was successfully updated.'
        format.html { redirect_to(@guest_msg) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @guest_msg.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /guest_msgs/1
  # DELETE /guest_msgs/1.xml
  def destroy
    @guest_msg = GuestMsg.find(params[:id])
    @guest_msg.destroy

    respond_to do |format|
      format.html { redirect_to(guest_msgs_url) }
      format.xml  { head :ok }
    end
  end
end
