class AddFieldsToJob < ActiveRecord::Migration[6.1]
  def change
    add_column :jobs, :name, :string
    add_column :jobs, :abbr, :string
    add_column :jobs, :category, :string
  end
end
