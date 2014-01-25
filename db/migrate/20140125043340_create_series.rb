class CreateSeries < ActiveRecord::Migration
  def change
    create_table :series    do |t|
      t.string :series_id # the series already has this string UK, but will active record default to making an integer key?
      t.string :name
      t.string :units
      t.string :f
      t.text :description
      t.string :copyright
      t.string :source
      t.string :iso3116
      t.string :start
      t.string :end
      t.string :last_updated
      t.string :unitsshort
      t.float :lat
      t.float :lon

      t.timestamps
    end
  end
end
