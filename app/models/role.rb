class Role < ActiveRecord::Base
  self.primary_key = "id"
  belongs_to :movie
  belongs_to :crew
end
