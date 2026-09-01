class Invitation < ApplicationRecord
  belongs_to :inviter, class_name: "User", foreign_key: :inviter_id

  validates :email, presence: true
  validates :token, presence: true, uniqueness: true
end
