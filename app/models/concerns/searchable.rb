module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    # Customize the index name
    #
    index_name [File.basename(Rails.root).downcase, Rails.env.to_s].join('-')

    # Set up index configuration and mapping
    #
    settings index: { number_of_shards: 1, number_of_replicas: 0 } do
      mapping do
        indexes :name, type: 'multi_field' do
          indexes :name,     analyzer: 'snowball'
          indexes :tokenized, analyzer: 'simple'
        end

        indexes :description, type: 'multi_field' do
          indexes :description,   analyzer: 'snowball'
          indexes :tokenized, analyzer: 'simple'
        end

        # indexes :published_on, type: 'date'

        # indexes :authors do
        #   indexes :full_name, type: 'multi_field' do
        #     indexes :full_name
        #     indexes :raw, analyzer: 'keyword'
        #   end
        # end

        # indexes :categories, analyzer: 'keyword'

        # indexes :comments, type: 'nested' do
        #   indexes :body, analyzer: 'snowball'
        #   indexes :stars
        #   indexes :pick
        #   indexes :user, analyzer: 'keyword'
        #   indexes :user_location, type: 'multi_field' do
        #     indexes :user_location
        #     indexes :raw, analyzer: 'keyword'
        #   end
        # end
      end
    end

    # Set up callbacks for updating the index on model changes
    #
    after_commit lambda { Indexer.perform_async(:index,  self.class.to_s, self.id) }, on: :create
    after_commit lambda { Indexer.perform_async(:update, self.class.to_s, self.id) }, on: :update
    after_commit lambda { Indexer.perform_async(:delete, self.class.to_s, self.id) }, on: :destroy
    after_touch  lambda { Indexer.perform_async(:update, self.class.to_s, self.id) }

    # Customize the JSON serialization for Elasticsearch
    #
    # def as_indexed_json(options={})
    #   hash = self.as_json(
    #     include: { authors:    { methods: [:full_name], only: [:full_name] },
    #                comments:   { only: [:body, :stars, :pick, :user, :user_location] }
    #              })
    #   hash['categories'] = self.categories.map(&:title)
    #   hash
    # end
  end

  module ClassMethods

    # Search in title and content fields for `query`, include highlights in response
    #
    # @param query [String] The user query
    # @return [Elasticsearch::Model::Response::Response]
    #
    def search(query, options={})

      # Prefill and set the filters (top-level `filter` and `facet_filter` elements)
      #
      __set_filters = lambda do |key, f|

        @search_definition[:filter][:and] ||= []
        @search_definition[:filter][:and]  |= [f]

        @search_definition[:facets][key.to_sym][:facet_filter][:and] ||= []
        @search_definition[:facets][key.to_sym][:facet_filter][:and]  |= [f]
      end

      @search_definition = {
        query: {},

        highlight: {
          pre_tags: ['<em class="label label-highlight">'],
          post_tags: ['</em>'],
          fields: {
            name:    { number_of_fragments: 0 },
            description: { number_of_fragments: 0 }
          }
        },

        filter: {},

        # facets: {
        #   categories: {
        #     terms: {
        #       field: 'categories'
        #     },
        #     facet_filter: {}
        #   },
        #   authors: {
        #     terms: {
        #       field: 'authors.full_name.raw'
        #     },
        #     facet_filter: {}
        #   },
        #   published: {
        #     date_histogram: {
        #       field: 'published_on',
        #       interval: 'week'
        #     },
        #     facet_filter: {}
        #   }
        # }
      }

      unless query.blank?
         @search_definition[:query] = {
          bool: {
            should: [
              { multi_match: {
                  query: query,
                  fields: ['name^2', 'description'],
                  operator: 'and'
                }
              }
            ]
          }
        }


      else
        @search_definition[:query] = { match_all: {} }
        @search_definition[:sort]  = {  }
      end

      # if options[:category]
      #   f = { term: { categories: options[:category] } }

      #   __set_filters.(:authors, f)
      #   __set_filters.(:published, f)

      #   @search_definition[:facets][:published][:facet_filter]       ||= {}
      #   @search_definition[:facets][:published][:facet_filter][:and] ||= []
      #   @search_definition[:facets][:published][:facet_filter][:and] << f
      # end

      # if options[:author]
      #   f = { term: { 'authors.full_name.raw' => options[:author] } }

      #   __set_filters.(:categories, f)
      #   __set_filters.(:published, f)

      #   @search_definition[:facets][:published][:facet_filter]       ||= {}
      #   @search_definition[:facets][:published][:facet_filter][:and] ||= []
      #   @search_definition[:facets][:published][:facet_filter][:and] << f
      # end

      # if options[:published_week]
      #   f = {
      #     range: {
      #       published_on: {
      #         gte: options[:published_week],
      #         lte: "#{options[:published_week]}||+1w"
      #       }
      #     }
      #   }

      #   __set_filters.(:categories, f)
      #   __set_filters.(:authors, f)
      # end

      # if query.present? && options[:comments]
      #   @search_definition[:query][:bool][:should] ||= []
      #   @search_definition[:query][:bool][:should] << {
      #     nested: {
      #       path: 'comments',
      #       query: {
      #         multi_match: {
      #           query: query,
      #           fields: ['body'],
      #           operator: 'and'
      #         }
      #       }
      #     }
      #   }
      #   @search_definition[:highlight][:fields].update 'comments.body' => { fragment_size: 50 }
      # end

      if options[:sort]
        @search_definition[:sort]  = { options[:sort] => 'desc' }
        @search_definition[:track_scores] = true
      end

      unless query.blank?
        @search_definition[:suggest] = {
          text: query,
          suggest_title: {
            term: {
              field: 'name',
              suggest_mode: 'always'
            }
          }
        }
      end

      __elasticsearch__.search(@search_definition)
    end
  end
end
