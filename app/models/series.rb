class Series < ActiveRecord::Base
  belongs_to :category
  # , after_add:    [ lambda { |a,c| Indexer.perform_async(:update,  a.class.to_s, a.id) } ],
  #                                      after_remove: [ lambda { |a,c| Indexer.perform_async(:update,  a.class.to_s, a.id) } ]
  has_many                :data
  # has_many                :authors, through: :authorships
  # has_many                :comments


  include Searchable
end
