class User < ApplicationRecord
  devise :database_authenticatable,
         :recoverable,
         :rememberable,
         :validatable

  belongs_to :role

  has_many :subscriptions, dependent: :destroy
  has_many :transactions, dependent: :destroy

  has_one :payment_authorization, dependent: :destroy

  has_many :sent_invitations,
           class_name: "Invitation",
           foreign_key: :inviter_id,
           dependent: :destroy

  has_one_attached :profile_photo

  validates :name, presence: true

  validates :billing_day,
            numericality: {
              only_integer: true,
              in: 1..30
            },
            allow_nil: true

  def admin?
    role.role == "Admin"
  end

  def buyer?
    role.role == "Buyer"
  end
end
