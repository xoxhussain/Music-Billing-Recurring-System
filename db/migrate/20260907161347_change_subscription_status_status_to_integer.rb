class ChangeSubscriptionStatusStatusToInteger < ActiveRecord::Migration[8.1]
  def up
    change_column :subscription_statuses, :status, :integer, default: 0, null: false
  end

  def down
    change_column :subscription_statuses, :status, :string
  end
end
