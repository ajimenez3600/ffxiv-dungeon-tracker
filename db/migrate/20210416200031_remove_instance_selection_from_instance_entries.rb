class RemoveInstanceSelectionFromInstanceEntries < ActiveRecord::Migration[6.1]
  def change
    remove_column :instance_entries, :instance_selection
  end
end
