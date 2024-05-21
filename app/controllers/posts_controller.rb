class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]

  # GET /posts or /posts.json
  def index
    # span_id = Datadog.current_span_id
    # context = Datadog::Tracing.send(:tracer).provider.context
    # https://github.com/DataDog/dd-trace-rb/blob/master/docs/UpgradeGuide.md
    trace_digest = Datadog::Tracing.active_trace.to_digest
    Parallel.map(['es', 'api', 'sleep'], in_threads: 2) do |type|
      # Datadog::Tracing.continue_trace!(trace_digest)
      Datadog::Tracing.trace('parallel', continue_from: trace_digest) do |span, trace|
        case type
        when 'es'
          @posts = Post.search(params[:query] || {}).records.to_a
        when 'api'
          @products = fetch_products
        when 'sleep'
          sleep 0.1
          Post.first
        end
      end
    end
  end

  # GET /posts/1 or /posts/1.json
  def show; end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit; end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to post_url(@post), notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post =
      Rails.cache.fetch("posts/#{params[:id]}") do
        Post.find(params[:id])
      end
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:title, :body)
  end

  def fetch_products
    connection = Faraday.new(url: 'https://dummyjson.com') do |faraday|
      faraday.response :json
    end
    response = connection.get '/products/1'
    response.body
  end
end
