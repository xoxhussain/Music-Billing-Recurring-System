class Role < ApplicationRecord
  has_many :users, dependent: :restrict_with_error

  validates :role, presence: true, uniqueness: true
end
