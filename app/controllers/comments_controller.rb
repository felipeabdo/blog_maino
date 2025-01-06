class CommentsController < ApplicationController
  before_action :set_post, only: %i[create destroy]
  before_action :find_comment, only: %i[destroy]
  before_action :authenticate_user!, only: %i[destroy], except: %i[create]

  def create
    @post = Post.find_by(id: params[:comment][:post_id])
    unless @post
      flash[:alert] = "Post não encontrado."
      redirect_to root_path and return
    end

    @comment = @post.comments.build(comment_params)
    if user_signed_in?
      @comment.user = current_user
      @comment.username = current_user.username
    else
      @comment.username = "Anônimo"
      @comment.user = nil
    end

    puts "Tentando salvar comentário: #{@comment.inspect}"
    
    if @comment.save
      puts "Comentário salvo com sucesso: #{@comment.inspect}"
      redirect_to @post, notice: "Comentário publicado com sucesso."
    else
      puts "Erro ao salvar comentário: #{@comment.errors.full_messages.join(', ')}"
      @comments = @post.comments
      flash[:alert] = "Erro: O comentário não pode estar vazio."
      render "posts/show", status: :unprocessable_entity
    end
  end

  def destroy
    if @comment.present?
      puts "Comentário encontrado: #{@comment.id}"
      puts "Usuário atual: #{current_user.id}, Autor do comentário: #{@comment.user_id}, Autor do post: #{@post.user_id}"
      if current_user.id == @comment.user_id || current_user.id == @post.user_id
        @comment.destroy
        puts "Comentário deletado: #{@comment.id}"
        redirect_to @post, notice: "Comentário deletado com sucesso."
      else
        puts "Usuário atual não tem permissão para deletar este comentário"
        redirect_to @post, alert: "Você não tem permissão para deletar este comentário."
      end
    else
      puts "Comentário não encontrado"
      redirect_to @post, alert: "Comentário não encontrado."
    end
  end

  private

  def set_post
    if params[:comment]
      @post = Post.find(params[:comment][:post_id])
    else
      @post = Post.find(params[:post_id])
    end
    puts "Post encontrado: #{@post.id}"
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Post não encontrado."
    redirect_to root_path
  end

  def find_comment
    puts "Tentando encontrar comentário com ID: #{params[:id]} e Post ID: #{params[:post_id]}"
    @comment = Comment.find_by(id: params[:id])
    puts "Comentário encontrado: #{@comment&.id}"
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
