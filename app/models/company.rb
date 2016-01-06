class Company
  include Mongoid::Document
  field :name, type: String
  field :link, type: String
  field :data, type: Hash
  
  
  embedded_in :txt_file
end
