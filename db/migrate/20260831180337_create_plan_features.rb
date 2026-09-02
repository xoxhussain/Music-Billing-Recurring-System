class CreatePlanFeatures < ActiveRecord::Migration[8.1]
  def change
    create_table :plan_features do |t|
      t.references :plan, null: false, foreign_key: true
      t.references :feature, null: false, foreign_key: true
      t.decimal :max_unit_price

      t.timestamps
    end

    add_index :plan_features,
              [ :plan_id, :feature_id ],
              unique: true,
              name: "index_plan_features_on_plan_and_feature"
  end
end
