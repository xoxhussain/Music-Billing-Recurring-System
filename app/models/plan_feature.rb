class PlanFeature < ApplicationRecord
  belongs_to :plan
  belongs_to :feature

  has_many :usage_entries, dependent: :restrict_with_error

  validates :feature_id, uniqueness: { scope: :plan_id }

  validates :max_unit_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end
