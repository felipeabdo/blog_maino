class AddUsernameToComments < ActiveRecord::Migration[7.2]
  def change
    add_column :comments, :username, :string
  end
end
