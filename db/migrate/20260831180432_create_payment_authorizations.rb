class CreatePaymentAuthorizations < ActiveRecord::Migration[8.1]
  def change
    create_table :payment_authorizations do |t|
      t.references :user, null: false, foreign_key: true
      t.string :stripe_customer_id
      t.string :stripe_payment_method_id
      t.boolean :authorized

      t.timestamps
    end
  end
end
