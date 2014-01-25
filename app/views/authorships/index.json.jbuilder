json.array!(@authorships) do |authorship|
  json.extract! authorship, :id, :article_id, :author_id
  json.url authorship_url(authorship, format: :json)
end
