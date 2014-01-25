class Article < ActiveRecord::Base
  has_and_belongs_to_many :categories, after_add:    [ lambda { |a,c| Indexer.perform_async(:update,  a.class.to_s, a.id) } ],
                                       after_remove: [ lambda { |a,c| Indexer.perform_async(:update,  a.class.to_s, a.id) } ]
  has_many                :authorships
  has_many                :authors, through: :authorships
  has_many                :comments


  include Searchable
end
