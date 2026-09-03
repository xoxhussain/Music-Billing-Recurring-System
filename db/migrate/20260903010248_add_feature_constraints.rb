class AddFeatureConstraints < ActiveRecord::Migration[8.1]
  def change
    add_check_constraint :features,
                         "unit_price >= 0",
                         name: "features_unit_price_non_negative"

    add_check_constraint :features,
                         "max_unit_limit >= 0",
                         name: "features_max_unit_limit_non_negative"
  end
end
