class CreateInstances < ActiveRecord::Migration[6.1]
  def change
    create_table :instances do |t|
      t.string :name
      t.string :type
      t.integer :min_level
      t.integer :max_level
      t.integer :min_ilvl
      t.integer :max_ilvl

      t.timestamps
    end
  end
end
