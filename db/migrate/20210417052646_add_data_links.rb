class AddDataLinks < ActiveRecord::Migration[6.1]
  def change
    remove_column :instance_entries, :job_name

    add_column :instance_entries, :job_id, :integer
    add_column :jobs, :role_id, :integer
  end
end
