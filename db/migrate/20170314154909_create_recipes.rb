class CreateRecipes < ActiveRecord::Migration[5.0]
  def change
    create_table :recipes do |t|
      t.string :title, default: " "
      t.string :description, default: " "
      t.string :meal, default: " "
      t.string :picture, default: " "
      t.integer :user_id

      t.timestamps
    end
    add_index :recipes, :user_id
  end
end
