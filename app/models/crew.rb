class Crew < ActiveRecord::Base
  has_many :roles
  has_many :movies, through: :roles

  self.primary_key = "id"

  validates :name, uniqueness: true
end
