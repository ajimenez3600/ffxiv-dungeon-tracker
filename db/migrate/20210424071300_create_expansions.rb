class CreateExpansions < ActiveRecord::Migration[6.1]
  def change
    create_table :expansions do |t|
      t.string :name
      t.integer :api_id

      t.timestamps
    end

    add_column :instances, :expansion_id, :integer
  end
end
