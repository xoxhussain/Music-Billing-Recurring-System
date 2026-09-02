class CreateTransactions < ActiveRecord::Migration[8.1]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :subscription, null: false, foreign_key: true
      t.decimal :amount
      t.integer :status, null: false
      t.string :transaction_type
      t.string :stripe_payment_id
      t.datetime :occurred_at

      t.timestamps
    end
  end
end
