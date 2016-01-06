json.array!(@txt_files) do |txt_file|
  json.extract! txt_file, :id, :name, :path
  json.url txt_file_url(txt_file, format: :json)
end
