class AddExpansionToInstances < ActiveRecord::Migration[6.1]
  def change
    add_column :instances, :expansion, :string
  end
end
