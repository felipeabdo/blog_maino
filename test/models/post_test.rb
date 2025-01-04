require "test_helper"

class PostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  post = Post.new
  test "Instância de post vazia não será salva" do
    assert_not post.save, "Post vazio foi salvo"
  end
end
