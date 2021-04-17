class RenameLevelsRecommendedDungeonToRecommendedDungeonId < ActiveRecord::Migration[6.1]
  def change
    remove_column :levels, :recommended_dungeon
    add_column :levels, :recommended_dungeon_id, :integer
  end
end
