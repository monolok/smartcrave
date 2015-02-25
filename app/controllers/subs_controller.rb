class SubsController < ApplicationController
  before_filter :check_privileges!, except: [:index, :show, :_show_image]
  before_filter :admin_value
  before_action :set_sub, only: [:show, :edit, :update, :push_sub, :push_sub_to_food, :destroy, :_show_image]

  # GET /subs
  # GET /subs.json
  def index
    @subs = Sub.all
  end

  # GET /subs/1
  # GET /subs/1.json
  def show
    if @sub.counter == nil
      @sub.update_attribute(:counter, 1)
    else
      @sub.update_attribute(:counter, @sub.counter+1)
    end
  end

  def _show_image
    send_data(Base64.decode64(@sub.image.data), :type => @sub.image.mime_type, :filename => @sub.image.filename, :disposition => 'inline')
  end

  # GET /subs/1/edit
  #def edit
  #end
  def push_sub
  end

  def push_sub_to_food
    params[:sub].each do |k, v|
      @food_id = v
    end
    @food = Food.find(@food_id)
    @food.subs << @sub

    redirect_to @food
  end

  def new
    @sub = Sub.new
    #@sub.build_image
  end
  def create
    @sub = Sub.new(sub_params)
    @sub.build_image(params['image']) do |t|
      if params['sub']['image']['data']
        t.data =      Base64.encode64(params['sub']['image']['data'].read)
        t.filename =  params['sub']['image']['data'].original_filename
        t.mime_type = params['sub']['image']['data'].content_type
      end
    end

    respond_to do |format|
      if @sub.save
        format.html { redirect_to @sub, notice: 'Sub was successfully created.' }
        format.json { render :show, status: :created, location: @sub }
      else
        format.html { render :new }
        format.json { render json: @sub.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  # PATCH/PUT /foods/1
  # PATCH/PUT /foods/1.json
  def update
   @sub.build_image(params['image']) do |t|
      if params['sub']['image']['data']
        t.data =      Base64.encode64(params['sub']['image']['data'].read)
        t.filename =  params['sub']['image']['data'].original_filename
        t.mime_type = params['sub']['image']['data'].content_type
      end
    end    
    respond_to do |format|
      if @sub.update(sub_params)
        format.html { redirect_to @sub, notice: 'Sub was successfully updated.' }
        format.json { render :show, status: :ok, location: @sub }
      else
        format.html { render :edit }
        format.json { render json: @sub.errors, status: :unprocessable_entity }
      end
    end
  end
  # PATCH/PUT /subs/1
  # PATCH/PUT /subs/1.json
  # def update
  #   respond_to do |format|
  #     if @sub.update(sub_params)
  #       format.html { redirect_to @sub, notice: 'Sub was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @sub }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @sub.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /subs/1
  # DELETE /subs/1.json
  def destroy
    @sub.destroy
    respond_to do |format|
      format.html { redirect_to subs_url, notice: 'Sub was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
      def check_privileges!
      @admin = User.where(admin: true)
      @god = Array.new
      @admin.each do |a|
        @god.push(a.id)
      end
      if not user_signed_in? 
        redirect_to controller: "devise/registrations", action: "new", notice: "Login or sign up to access content"
      else
        @check = @god.include? current_user.id
        redirect_to root_path, notice: 'You are not an admin' unless @check == true
      end
    end

    def admin_value
      @admin = User.where(admin: true)
      @god = Array.new

      @admin.each do |a|
      @god.push(a.id)
        end

      if user_signed_in?
        @admin = @god.include? current_user.id    
      else
        @admin = false
      end 
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_sub
      @sub = Sub.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sub_params
      params.require(:sub).permit(:name, :description, :counter, images_attributes: [:name, :data])
    end
end
