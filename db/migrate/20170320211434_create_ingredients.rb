class CreateIngredients < ActiveRecord::Migration[5.0]
  def change
    create_table :ingredients do |t|
      t.references :recipe, foreign_key: true
      t.string :amount, default: ""
      t.string :name, default: ""

      t.timestamps
    end
  end
end
