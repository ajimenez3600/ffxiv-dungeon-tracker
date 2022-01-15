class AddPatchNumberToInstanceEntries < ActiveRecord::Migration[6.1]
  def change
    add_column :instance_entries, :patch_number, :decimal, default: 5.55, precision: 5, scale: 2, null: false
  end
end
