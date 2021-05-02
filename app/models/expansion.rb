class Expansion < ApplicationRecord
  validates :name, presence: true
  validates :api_id, presence: true
  
  has_many :instances
end
