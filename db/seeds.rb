require 'zlib'
require 'yaml'
require 'json'

# Zlib::GzipReader.open(File.expand_path('../articles.yml.gz', __FILE__)) do |gzip|
#   puts "Reading articles from gzipped YAML..."
#   @documents = YAML.load_documents(gzip.read)
# end

def load_line(line)
    series = Series.create! line.except("data", "iso3166")
    series.save!
end

puts "Reading articles from sample ELEC file"
File.open(File.expand_path('../../ELEC_sample.json', __FILE__)).each_line do |line|
  # @documents = JSON.load(file.read)
  line = JSON.parse(line)
  load_line(line)
end

# Truncate the default ActiveRecord logger output
ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDERR)
ActiveRecord::Base.logger.instance_eval do
  @formatter = lambda do |s, d, p, message|
    message
      .gsub(/\[("content", ".*?")\]/m) { |match| match[0..100] + '..."]' }
      .gsub(/\[("body", ".*?")\]/m   ) { |match| match[0..100] + '..."]' }
      .strip
      .concat("\n")
  end
end

# Reduce verbosity and truncate the request body of Elasticsearch logger
Series.__elasticsearch__.client.transport.tracer.level = Logger::INFO
Series.__elasticsearch__.client.transport.tracer.formatter = lambda do |s, d, p, message|
  "\n\n" + (message.size > 105 ? message[0..105].concat("...}'") : message) + "\n\n"
end

# Skip callbacks
# %w| _touch_callbacks
#     _commit_callbacks
#     after_add_for_categories
#     after_add_for_authorships
#     after_add_for_authors
#     after_add_for_comments  |.each do |c|
#     Article.class.__send__ :define_method, c do; []; end
#   end

# @documents.each do |document|
#   series = Series.create! document.slice(:series_id, :name, :units,
#     :frequency,  :description,  :copyright,  :source,
#     :iso3116, :start, :end, :last_updated, :lat, :lon)




  # article.categories = document[:categories].map do |d|
  #   Category.find_or_create_by! title: d
  # end

  # article.authors = document[:authors].map do |d|
  #   first_name, last_name = d.split(' ').compact.map(&:strip)
  #   Author.find_or_create_by! first_name: first_name, last_name: last_name
  # end

  # document[:comments].each { |d| article.comments.create! d }

# Import records into the Elasticsearch index
#
Series.import  force: true, refresh: true
