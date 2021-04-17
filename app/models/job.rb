class Job < ApplicationRecord
  has_many :instance_entries
  belongs_to :role
end
