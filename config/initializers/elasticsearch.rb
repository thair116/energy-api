# Connect to specific Elasticsearch cluster
ELASTICSEARCH_URL = ENV['ELASTICSEARCH_URL'] || 'http://localhost:9200'

Elasticsearch::Model.client = Elasticsearch::Client.new host: ELASTICSEARCH_URL

# Print Curl-formatted traces in development
#
if Rails.env.development?
  tracer = ActiveSupport::Logger.new(STDERR)
  tracer.level =  Logger::DEBUG
end

Elasticsearch::Model.client.transport.tracer = tracer
