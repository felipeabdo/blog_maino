class AddUserIdToComments < ActiveRecord::Migration[7.2]
  def change
    add_reference :comments, :user, null: false, foreign_key: true, default: 1
    change_column_default :comments, :user_id, nil
  end
end
