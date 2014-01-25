class CategoriesChildSeries < ActiveRecord::Base
  self.table_name = "categories_child_series"

  belongs_to :category
end
