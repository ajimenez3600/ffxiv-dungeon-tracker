class AddFormFieldsToInstanceEntry < ActiveRecord::Migration[6.1]
  def change
    add_column :instance_entries, :start_time, :datetime
    add_column :instance_entries, :roulette_name, :string
    add_column :instance_entries, :job_name, :string
    add_column :instance_entries, :start_level, :integer
    add_column :instance_entries, :start_xp, :integer
    add_column :instance_entries, :queue_pop_time, :datetime
    add_column :instance_entries, :instance_selection, :string
    add_column :instance_entries, :finish_time, :datetime
    add_column :instance_entries, :finish_level, :integer
    add_column :instance_entries, :finish_xp, :integer
    add_column :instance_entries, :xp_bonus, :integer
    add_column :instance_entries, :roulette_bonus, :integer
    add_column :instance_entries, :new_player_bonus, :integer
    add_column :instance_entries, :role_in_need_bonus, :integer
    add_column :instance_entries, :other_bonus, :integer
    add_column :instance_entries, :commends, :integer
    add_column :instance_entries, :queue_outlier?, :boolean
    add_column :instance_entries, :duration_outlier?, :boolean
    add_column :instance_entries, :xp_outlier?, :boolean
    add_column :instance_entries, :notes, :string
  end
end
