class Crew < ApplicationRecord
  has_many :roles
  has_many :movies, through: :roles

  self.primary_key = "id"

  validates :name, uniqueness: true
end
