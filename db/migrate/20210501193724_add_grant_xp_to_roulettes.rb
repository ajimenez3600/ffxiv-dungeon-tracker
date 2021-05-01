class AddGrantXpToRoulettes < ActiveRecord::Migration[6.1]
  def change
    add_column :roulettes, :grant_xp, :boolean, null: false, default: false
  end
end
