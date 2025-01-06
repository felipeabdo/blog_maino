class CreateComments < ActiveRecord::Migration[7.2]
  def change
    create_table :comments do |t|
      t.references :post, null: false, foreign_key: true
      t.references :user, foreign_key: true, null: true  # Permite null em user_id para comentários anônimos
      t.string :username, null: true  # Para armazenar "Anônimo" ou o nome do usuário logado
      t.text :body, null: false  # O conteúdo do comentário

      t.timestamps
    end
  end
end
