class SubscriptionStatus < ApplicationRecord
  belongs_to :subscription

  enum :status, {
    active: "active",
    inactive: "inactive",
    halted: "halted",
    unsubscribed: "unsubscribed"
  }

  validates :status, presence: true
end
