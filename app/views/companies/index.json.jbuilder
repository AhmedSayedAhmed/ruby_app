json.array!(@companies) do |company|
  json.extract! company, :id, :name, :data
  json.url company_url(company, format: :json)
end
