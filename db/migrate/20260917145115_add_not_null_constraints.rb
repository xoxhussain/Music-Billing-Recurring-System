class AddNotNullConstraints < ActiveRecord::Migration[8.1]
  def change
    change_column_null :features, :unit_price, false
    change_column_null :features, :max_unit_limit, false

    change_column_null :subscriptions, :started_at, false
  end
end
