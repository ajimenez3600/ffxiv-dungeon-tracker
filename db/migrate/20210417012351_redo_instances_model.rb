class RedoInstancesModel < ActiveRecord::Migration[6.1]
  def change
    remove_column :instances, :min_level
    remove_column :instances, :max_level    
    remove_column :instances, :min_ilvl
    remove_column :instances, :max_ilvl
    
    add_column :instances, :api_id,                   :integer
    add_column :instances, :required_level,           :integer
    add_column :instances, :required_item_level,      :integer
    add_column :instances, :level_sync,               :integer
    add_column :instances, :item_level_sync,          :integer
    add_column :instances, :alliance_roulette?,       :boolean
    add_column :instances, :expert_roulette?,         :boolean
    add_column :instances, :guild_hest_roulette?,     :boolean
    add_column :instances, :level_50_60_70_roulette?, :boolean
    add_column :instances, :level_80_roulette?,       :boolean
    add_column :instances, :leveling_roulette?,       :boolean
    add_column :instances, :msq_roulette?,            :boolean
    add_column :instances, :mentor_roulette?,         :boolean
    add_column :instances, :normal_raid_roulette?,    :boolean
    add_column :instances, :trial_roulette?,          :boolean
    add_column :instances, :boss_1_exp,               :integer
    add_column :instances, :boss_2_exp,               :integer
    add_column :instances, :boss_3_exp,               :integer
    add_column :instances, :boss_4_exp,               :integer
    add_column :instances, :final_boss_exp,           :integer
    add_column :instances, :instance_clear_exp,       :integer
    add_column :instances, :new_player_bonus_a,       :integer
    add_column :instances, :new_player_bonus_b,       :integer
  end
end
