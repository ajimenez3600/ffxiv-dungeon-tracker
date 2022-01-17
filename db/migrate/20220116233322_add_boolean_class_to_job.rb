class AddBooleanClassToJob < ActiveRecord::Migration[6.1]
  def change
    add_column :jobs, :is_class, :boolean, default: false, null: false
  end
end
