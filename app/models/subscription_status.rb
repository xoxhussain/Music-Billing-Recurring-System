class SubscriptionStatus < ApplicationRecord
  belongs_to :subscription

  enum :status, {
    active: 0,
    inactive: 1,
    halted: 2,
    unsubscribed: 3
  }

  validates :status, presence: true
end
