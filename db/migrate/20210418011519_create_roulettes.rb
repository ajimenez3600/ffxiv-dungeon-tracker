class CreateRoulettes < ActiveRecord::Migration[6.1]
  def change
    create_table :roulettes do |t|
      t.string :name

      t.timestamps
    end
  end
end
