class Category < ActiveRecord::Base
  has_many :categories_child_series
end
