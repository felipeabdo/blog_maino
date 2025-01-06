class AddFileToPosts < ActiveRecord::Migration[7.2]
  def change
    add_column :posts, :file, :string
  end
end
