class UsageEntry < ApplicationRecord
  belongs_to :subscription
  belongs_to :plan_feature

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
