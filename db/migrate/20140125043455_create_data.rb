class CreateData < ActiveRecord::Migration
  def change
    create_table :data do |t|
      t.date :date
      t.integer :value

      t.timestamps
    end
  end
end
