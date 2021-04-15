class CreateInstanceEntries < ActiveRecord::Migration[6.1]
  def change
    create_table :instance_entries do |t|

      t.timestamps
    end
  end
end
