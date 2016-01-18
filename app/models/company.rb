class Company
  include Mongoid::Document
  field :name, type: String
  field :description, type: String
  field :link, type: String
  field :fblink, type: String
  field :data, type: Hash
end
