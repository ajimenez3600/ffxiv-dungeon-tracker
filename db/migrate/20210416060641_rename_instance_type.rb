class RenameInstanceType < ActiveRecord::Migration[6.1]
  def change
    rename_column :instances, :type, :instance_type
  end
end
