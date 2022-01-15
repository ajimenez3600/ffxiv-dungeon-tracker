class AddLuneTrackerToInstanceEntries < ActiveRecord::Migration[6.1]
  def change
    add_column :instance_entries, :lune_tracker, :string
  end
end
