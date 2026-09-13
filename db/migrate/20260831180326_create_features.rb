class CreateFeatures < ActiveRecord::Migration[8.1]
  def change
    create_table :features do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.decimal :unit_price
      t.integer :max_unit_limit

      t.timestamps
    end

    add_index :features, :code, unique: true
  end
end
