require 'zlib'
require 'yaml'
require 'json'

# def load_line(line)
#     series = Series.create! line.except("data", "iso3166")
#     series.save!
# end
# #
# # # we already do this manually by loading eia.sql
# # # or we could load ELEC.txt here
# # puts "Reading articles from sample ELEC file"
# # File.open(File.expand_path('../../ELEC_sample.json', __FILE__)).each_line do |line|
# #   # @documents = JSON.load(file.read)
# #   line = JSON.parse(line)
# #   load_line(line)
# # end

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
# Series.__elasticsearch__.client.transport.tracer.level = Logger::INFO
# Series.__elasticsearch__.client.transport.tracer.formatter = lambda do |s, d, p, message|
#   "\n\n" + (message.size > 105 ? message[0..105].concat("...}'") : message) + "\n\n"
# end

# Import records into the Elasticsearch index
#
Series.import  force: true, refresh: true
