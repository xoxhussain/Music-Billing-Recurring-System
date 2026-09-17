class PaymentAuthorization < ApplicationRecord
  belongs_to :user

  validates :stripe_customer_id, presence: true
  validates :stripe_payment_method_id, presence: true
end
