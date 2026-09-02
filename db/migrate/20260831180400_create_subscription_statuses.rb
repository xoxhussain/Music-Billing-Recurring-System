class CreateSubscriptionStatuses < ActiveRecord::Migration[8.1]
  def change
    create_table :subscription_statuses do |t|
      t.references :subscription, null: false, foreign_key: true
      t.integer :status, null: false
      t.boolean :is_using, null: false, default: false

      t.timestamps
    end
  end
end
