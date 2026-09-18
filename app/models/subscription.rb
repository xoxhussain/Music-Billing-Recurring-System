class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :plan

  has_many :subscription_statuses, dependent: :destroy
  has_many :usage_entries, dependent: :destroy
  has_many :transactions, dependent: :destroy

  validates :started_at, presence: true

  scope :with_details, -> { includes(:user, :plan, :subscription_statuses, usage_entries: { plan_feature: :feature }) }

  validate :payment_authorized, on: :create
  validate :no_active_duplicate_plan, on: :create

  scope :active, -> { where(unsubscribed_at: nil) }

  def usage_for(plan_feature)
    usage_entries.where(plan_feature_id: plan_feature.id).sum(:quantity)
  end

  def usage_exceeded?(plan_feature)
    max_limit = plan_feature.feature.max_unit_limit

    return false if max_limit.nil?

    usage_for(plan_feature) > max_limit
  end

  private

  def payment_authorized
    unless user.payment_authorization&.authorized?
      errors.add(:base, "Payment Authorization is required")
    end
  end

  def no_active_duplicate_plan
    if user.subscriptions.active.where(plan_id: plan_id).exists?
      errors.add(:plan, "already exists")
    end
  end
end
