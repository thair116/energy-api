class AddColumnsToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :abstract, :text
    add_column :articles, :url, :string
    add_column :articles, :shares, :integer
  end
end
