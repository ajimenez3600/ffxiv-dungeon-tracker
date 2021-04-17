class AddRecommendedDungeonToLevels < ActiveRecord::Migration[6.1]
  def change
    add_column :levels, :recommended_dungeon, :integer
  end
end
