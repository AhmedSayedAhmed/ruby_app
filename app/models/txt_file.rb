class TxtFile
	include Mongoid::Document
	field :id, type: Integer
	field :name, type: String
	field :path, type: String
end
