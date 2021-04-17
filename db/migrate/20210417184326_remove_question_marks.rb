class RemoveQuestionMarks < ActiveRecord::Migration[6.1]
  def change
    remove_column :instance_entries, :queue_outlier?, :boolean
    remove_column :instance_entries, :duration_outlier?, :boolean
    remove_column :instance_entries, :xp_outlier?, :boolean
    add_column :instance_entries, :queue_outlier, :boolean
    add_column :instance_entries, :duration_outlier, :boolean
    add_column :instance_entries, :xp_outlier, :boolean

    remove_column :instances, :alliance_roulette?, :boolean
    remove_column :instances, :expert_roulette?, :boolean
    remove_column :instances, :guild_hest_roulette?, :boolean
    remove_column :instances, :level_50_60_70_roulette?, :boolean
    remove_column :instances, :level_80_roulette?, :boolean
    remove_column :instances, :leveling_roulette?, :boolean
    remove_column :instances, :msq_roulette?, :boolean
    remove_column :instances, :mentor_roulette?, :boolean
    remove_column :instances, :normal_raid_roulette?, :boolean
    remove_column :instances, :trial_roulette?, :boolean
    add_column :instances, :alliance_roulette, :boolean
    add_column :instances, :expert_roulette, :boolean
    add_column :instances, :guild_hest_roulette, :boolean
    add_column :instances, :level_50_60_70_roulette, :boolean
    add_column :instances, :level_80_roulette, :boolean
    add_column :instances, :leveling_roulette, :boolean
    add_column :instances, :msq_roulette, :boolean
    add_column :instances, :mentor_roulette, :boolean
    add_column :instances, :normal_raid_roulette, :boolean
    add_column :instances, :trial_roulette, :boolean
  end
end
