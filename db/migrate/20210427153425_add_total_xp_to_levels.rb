class AddTotalXpToLevels < ActiveRecord::Migration[6.1]
  def change
    add_column :levels, :total_xp, :integer
  end
end
