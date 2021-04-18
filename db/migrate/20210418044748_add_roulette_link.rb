class AddRouletteLink < ActiveRecord::Migration[6.1]
  def change
    remove_column :instance_entries, :roulette_name
    add_column :instance_entries, :roulette_id, :integer
  end
end
