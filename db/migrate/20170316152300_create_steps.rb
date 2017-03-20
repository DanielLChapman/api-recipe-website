class CreateSteps < ActiveRecord::Migration[5.0]
  def change
    create_table :steps do |t|
      t.string :instruction, default: ""
      t.integer :order, default: 1
      t.integer :recipe_id

      t.timestamps
    end
    add_index :steps, :recipe_id
  end
end
