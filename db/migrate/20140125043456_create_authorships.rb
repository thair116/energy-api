class CreateAuthorships < ActiveRecord::Migration
  def change
    create_table :authorships do |t|
      t.references :article, index: true
      t.references :author, index: true

      t.timestamps
    end
  end
end
