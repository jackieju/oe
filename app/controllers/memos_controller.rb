class MemosController < ApplicationController
  # GET /memos
  # GET /memos.xml
   before_filter :login_required 
  def index
    @memos = Memo.find_by_sql("select * from memos where uid=#{current_user[:id]}")
    if !@memos || @memos.size ==0
      m = Memo.new({
       :content=>"this is a memo",
       :uid=>current_user[:id]
      });
      m.save();
      @memos[0] = m;
    else
      for memo in @memos do
        logger.info "-----dd>#{memo[:position]}"
        if (memo[:position] && memo[:position].size >0 )
          memo[:pos] = ActiveSupport::JSON.decode(memo[:position])
        else
          memo[:pos] = {'left'=>0,'top'=>0, 'width'=>200, 'height'=>150}
        end
         logger.info "----->#{memo[:pos]['left']}"
      end
    end
 
    render :layout=>false
  end
  
  def addNewMemo
    logger.info "----------777777"
    r = ActiveRecord::Base.connection.execute("select count(*) from memos where uid=#{current_user[:id]}")
    @number = r.fetch_row[0].to_i+1
    if (@number>10)
      render :text=>"<script>showErrDlg('便签数量达到上限')</script>"
      return
    end
    @memo= Memo.new({
     :content=>"this is a memo",
     :uid=>current_user[:id]
    });
    @memo.save
    render :layout=>false
  end
  
  def save
    logger.info("->>>>>>save")
    if (params[:memoid] == "dummy")
      render :text=>"Memo saved at #{DateTime.now}"
      return 
    end
    id = params[:memoid]
    content = params[:content]
    memo = Memo.find(id)
    memo[:content] = content
    memo.save!
    render :text=>"Memo saved at #{DateTime.now}"
  end
  
  def del
    logger.info("->>>>>>del")
    id = params[:memoid]
    content = params[:content]
    Memo.delete(id)
    render :text=>"Memo deleted at #{DateTime.now}"
  end
  
  def savePos
     logger.info("->>>>>>savePos")
    id = params[:memoid]
    pos = params[:pos]
    logger.info("->>>>>>#{pos}")
    memo = Memo.find(id)
    memo[:position] = pos
    memo.save!
    render :text=>"Memo saved at #{DateTime.now}"
  end
=begin
  def index
    @memos = Memo.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @memos }
    end
  end

  # GET /memos/1
  # GET /memos/1.xml
  def show
    @memo = Memo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @memo }
    end
  end

  # GET /memos/new
  # GET /memos/new.xml
  def new
    @memo = Memo.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @memo }
    end
  end

  # GET /memos/1/edit
  def edit
    @memo = Memo.find(params[:id])
  end

  # POST /memos
  # POST /memos.xml
  def create
    @memo = Memo.new(params[:memo])

    respond_to do |format|
      if @memo.save
        flash[:notice] = 'Memo was successfully created.'
        format.html { redirect_to(@memo) }
        format.xml  { render :xml => @memo, :status => :created, :location => @memo }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @memo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /memos/1
  # PUT /memos/1.xml
  def update
    @memo = Memo.find(params[:id])

    respond_to do |format|
      if @memo.update_attributes(params[:memo])
        flash[:notice] = 'Memo was successfully updated.'
        format.html { redirect_to(@memo) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @memo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /memos/1
  # DELETE /memos/1.xml
  def destroy
    @memo = Memo.find(params[:id])
    @memo.destroy

    respond_to do |format|
      format.html { redirect_to(memos_url) }
      format.xml  { head :ok }
    end
  end
=end
end
