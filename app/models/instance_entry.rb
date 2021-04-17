class InstanceEntry < ApplicationRecord
  belongs_to :instance, dependent: :destroy
  belongs_to :job
end
