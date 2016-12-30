class Genre < ActiveRecord::Base
  self.primary_key = "id"
	has_and_belongs_to_many :movies

  validates :name, uniqueness: true
end
