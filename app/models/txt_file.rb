class TxtFile
  include Mongoid::Document
  field :name, type: String
  field :path, type: String
  
  embeds_many :companies
end
