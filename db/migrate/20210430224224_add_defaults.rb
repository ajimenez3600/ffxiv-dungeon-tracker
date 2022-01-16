class AddDefaults < ActiveRecord::Migration[6.1]
  def change
    change_column :instance_entries, :start_level,   :integer,  null: false
    change_column :instance_entries, :start_xp,      :integer,  null: false
    change_column :instance_entries, :finish_level,  :integer,  null: false
    change_column :instance_entries, :finish_xp,     :integer,  null: false

    change_column :instance_entries, :start_time,      :datetime,  null: false
    change_column :instance_entries, :queue_pop_time,  :datetime,  null: false
    change_column :instance_entries, :finish_time,     :datetime,  null: false

    change_column :instance_entries, :xp_outlier,        :boolean,  null: false,  default: 0
    change_column :instance_entries, :queue_outlier,     :boolean,  null: false,  default: 0
    change_column :instance_entries, :duration_outlier,  :boolean,  null: false,  default: 0

    change_column :instance_entries, :roulette_bonus,      :integer,  null: false,  default: 0
    change_column :instance_entries, :role_in_need_bonus,  :integer,  null: false,  default: 0
    change_column :instance_entries, :new_player_bonus,    :integer,  null: false,  default: 0
    change_column :instance_entries, :other_bonus,         :integer,  null: false,  default: 0

    change_column :instance_entries, :xp_bonus,  :integer,  null: false,  default: 100
    change_column :instance_entries, :commends,  :integer,  null: false,  default: 0
    change_column :instance_entries, :notes,     :string,   null: false,  default: 0
  end
end