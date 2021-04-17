class CreateLevels < ActiveRecord::Migration[6.1]
  def change
    create_table :levels do |t|
      t.integer :number
      t.integer :exp_to_next
      t.integer :item_level_sync

      t.timestamps
    end
  end
end
