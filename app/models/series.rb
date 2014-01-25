class Series < ActiveRecord::Base
  belongs_to :category
  # , after_add:    [ lambda { |a,c| Indexer.perform_async(:update,  a.class.to_s, a.id) } ],
  #                                      after_remove: [ lambda { |a,c| Indexer.perform_async(:update,  a.class.to_s, a.id) } ]
  has_many                :data
  # has_many                :authors, through: :authorships
  # has_many                :comments

  def category_id
    CategoriesChildSeries.where(series_id_name: series_id).first.category_id
  end

  include Searchable
end
