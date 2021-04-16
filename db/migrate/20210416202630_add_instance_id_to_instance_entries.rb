class AddInstanceIdToInstanceEntries < ActiveRecord::Migration[6.1]
  def change
    add_column :instance_entries, :instance_id, :integer
  end
end
