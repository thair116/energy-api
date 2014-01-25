class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories, id: false  do |t|
      t.integer :category_id
      t.integer :parent_id
      t.string  :name
      t.string  :notes

      t.timestamps
    end
  end
end
