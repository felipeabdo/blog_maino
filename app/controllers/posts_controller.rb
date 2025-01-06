class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]
  # before_action :authenticate_user!, except: [:index, :show]

  def index
    @posts = Post.page(params[:page]).per(3).order(created_at: :desc)
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.order(created_at: :desc)
    @comment = Comment.new
  end

  def new
    @post = Post.new
    @post.user = current_user
  end

  def edit
  end

  def create
    @post = current_user.posts.build(post_params)
    respond_to do |format|
      if @post.save
        if @post.file.attached?
          file_blob_id = @post.file.blob.id
          Rails.logger.info "Enqueuing ProcessFileJob for file blob ID: #{file_blob_id}"
          ProcessFileJob.perform_later(file_blob_id)
        else
          Rails.logger.error "No file attached to post"
        end
        format.html { redirect_to @post, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        Rails.logger.error "Failed to create post: #{@post.errors.full_messages.join(', ')}"
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy!
    respond_to do |format|
      format.html { redirect_to posts_path, status: :see_other, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :image, :file, :tag_list)
  end
end
