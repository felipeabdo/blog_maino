class AddAuthorNameToPosts < ActiveRecord::Migration[7.2]
  def change
    add_column :posts, :author_name, :string
  end
end
