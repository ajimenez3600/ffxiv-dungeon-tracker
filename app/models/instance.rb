class Instance < ApplicationRecord
  belongs_to :expansion
  has_many :instance_entries
end
