class FoodsController < ApplicationController
  before_filter :check_privileges!, except: [:index, :show, :search, :create_idea]
  before_filter :admin_value
  before_action :set_food, only: [:show, :edit, :update, :destroy]
  # GET /foods
  # GET /foods.json
  def search
    if params[:search].present?
     @foods = Food.search(params[:search]).paginate(:page => params[:page], :per_page => 4)
     @subs = Sub.search(params[:search]).paginate(:page => params[:page], :per_page => 4)
    else
      redirect_to root_path
    end

    #counter for search
    if params[:search].present? || params[:search].present? == false
    @foods_search = Food.all
    @subs_search = Sub.all
#food
    @counters = Hash.new
    @foods_search.each do |c|
      @counters[c.id] = c.counter
    end
    
    @popular_foods = Array.new
    @counters = @counters.sort {|k, v| k[1]<=>v[1]}.reverse
    @counters.each do |id, counter|
      @popular_foods << Food.find(id)
    end
#sub
    @counters_sub = Hash.new
    @subs_search.each do |c|
      @counters_sub[c.id] = c.counter
    end
    
    @popular_subs = Array.new
    @counters_sub = @counters_sub.sort {|k, v| k[1]<=>v[1]}.reverse
    @counters_sub.each do |id, counter|
      @popular_subs << Sub.find(id)
    end
#results
    @popular_foods = @popular_foods[0...3]
    @popular_subs = @popular_subs[0...3]
    end
  end

  def index
    @foods = Food.all #.paginate(:page => params[:page], :per_page => 4)
    @subs = Sub.all #.paginate(:page => params[:page], :per_page => 4)
#food
    @counters = Hash.new
    @foods.each do |c|
      @counters[c.id] = c.counter
    end

    @popular_foods = Array.new
    if @counters.empty? #add or if @counters.include? nil remove nil record
      @counters = nil
    else
      @counters = @counters.keys.sort {|a, b| @counters[b] <=> @counters[a]}
      @counters.each do |id, counter|
       @popular_foods << Food.find(id)
      end
    end

#sub
    @counters_sub = Hash.new
    @subs.each do |c|
      @counters_sub[c.id] = c.counter
    end
    
    @popular_subs = Array.new
    if @counters_sub.empty? #add or if @counters.include? nil remove nil record
      @counters_sub = nil
    else
      @counters_sub = @counters_sub.keys.sort {|a, b| @counters_sub[b] <=> @counters_sub[a]}
      @counters_sub.each do |id, counter|
        @popular_subs << Sub.find(id)
      end     
    end

#results
    @popular_foods = @popular_foods[0...3]
    @popular_subs = @popular_subs[0...3]
  end

  # GET /foods/1
  # GET /foods/1.json
  def show
    if @food.counter == nil
      @food.update_attribute(:counter, 1)
    else
      @food.update_attribute(:counter, @food.counter+1)
    end
    send_data(Base64.decode64(@food.image.data), :type => @food.image.mime_type, :filename => @food.image.filename, :disposition => 'inline')
  end
  #send_data(@photo.data, :type => @photo.mime_type, :filename => "#{@photo.name}.jpg", :disposition => "inline")
  # GET /foods/new
  def new
    @food = Food.new
    @food.subs.build
    @food.build_image
  end

  # def _index_ideas
  #   @ideas = Idea.all
  # end
  # def _new_idea
  #   @idea = Idea.new
  # end
  def create_idea
    @idea = Idea.new(idea_params)

    respond_to do |format|
      if @idea.save
        format.html { redirect_to root_path, notice: 'Idea successfully submitted' }
        format.json { render :show, status: :created, location: root_path }
      else
        format.html { render :new }
        format.json { render json: @idea.errors, status: :unprocessable_entity }
      end
    end    
  end

  def destroy_idea
    @idea = Idea.find(params[:id])
    @idea.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Idea was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  # GET /foods/1/edit
  def edit
  end

  # def push_sub_name
  #   @sub = 
  #   @food.subs << @sub
  # end
  
  # POST /foods
  # POST /foods.json
  def create
    #@image = Image.create(name: params['food']['image'])
    @food = Food.new(food_params)
    @food.build_image(params['image']) do |t|
      if params['food']['image']['data']
        t.data =      Base64.encode64(params['food']['image']['data'].read)
        t.filename =  params['food']['image']['data'].original_filename
        t.mime_type = params['food']['image']['data'].content_type
      end
    end
    
    respond_to do |format|
      if @food.save
        format.html { redirect_to @food, notice: 'Food was successfully created.' }
        format.json { render :show, status: :created, location: @food }
      else
        format.html { render :new }
        format.json { render json: @food.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /foods/1
  # PATCH/PUT /foods/1.json
  def update
    respond_to do |format|
      if @food.update(food_params)
        format.html { redirect_to @food, notice: 'Food was successfully updated.' }
        format.json { render :show, status: :ok, location: @food }
      else
        format.html { render :edit }
        format.json { render json: @food.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /foods/1
  # DELETE /foods/1.json
  def destroy
    @food.destroy
    respond_to do |format|
      format.html { redirect_to foods_url, notice: 'Food was successfully destroyed.' }
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
    def set_food
      @food = Food.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def food_params
      params.require(:food).permit(:name, :description, :counter, images_attributes: [:name, :data], subs_attributes: [:id, :name, :description, :image, :_destroy])
    end

    def idea_params
      params.require(:idea).permit(:name, :description)
    end

end
