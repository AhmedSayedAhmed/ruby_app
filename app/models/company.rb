class Company
  include Mongoid::Document
  field :name, type: String
  field :description, type: String
  field :link, type: String
  field :social,  type: Hash, default: Hash.new
  field :data, type: Hash, default: Hash.new
  field :emails, type: Hash, default: Hash.new
end
