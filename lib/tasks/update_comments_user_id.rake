# lib/tasks/update_comments_user_id.rake
namespace :comments do
  desc "Update user_id for existing comments"
  task update_user_id: :environment do
    default_user_id = 1  # Substitua 1 pelo ID de um usuário válido
    Comment.where(user_id: nil).update_all(user_id: default_user_id)
  end
end
