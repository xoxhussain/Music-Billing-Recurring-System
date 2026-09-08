class SetDefaultAndNotNullOnPaymentAuthorizationAuthorized < ActiveRecord::Migration[8.1]
  def change
    change_column_default :payment_authorizations, :authorized, false
    change_column_null :payment_authorizations, :authorized, false
  end
end
