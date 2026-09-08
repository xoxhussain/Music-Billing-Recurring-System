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

  scope :with_details, -> {
    includes(
      :user,
      :plan,
      :subscription_statuses,
      usage_entries: { plan_feature: :feature }
    )
  }

  private

  def payment_authorized
    unless user.payment_authorization&.authorized?
      errors.add(:base, "Payment Authorization is required")
    end
  end

  def no_active_duplicate_plan
    if user.subscriptions
        .where(plan_id: plan_id)
        .where(unsubscribed_at: nil)
        .exists?
      errors.add(:plan, "already exists")
    end
  end
end
