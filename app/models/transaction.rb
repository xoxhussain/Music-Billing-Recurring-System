class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :subscription

  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

  validates :occured_at, presence: true
end
