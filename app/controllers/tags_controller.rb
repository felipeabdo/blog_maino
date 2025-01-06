# app/controllers/tags_controller.rb
class TagsController < ApplicationController
  def show
    @tag = Tag.find(params[:id])
    @posts = @tag.posts.page(params[:page]).per(3)
    render 'posts/index'
  end
end
