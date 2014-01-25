class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body
      t.string :user
      t.string :user_location
      t.integer :stars
      t.boolean :pick
      t.references :article, index: true

      t.timestamps
    end
  end
end
