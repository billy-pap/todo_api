class User < ApplicationRecord
  has_secure_password
  has_many :todos, dependent: :destroy

  validates :email, presence: true, uniqueness: true

  before_create :generate_auth_token

  def generate_auth_token
    self.auth_token = SecureRandom.hex(24)
  end

  def rotate_auth_token!
    update!(auth_token: SecureRandom.hex(24))
  end

  def invalidate_auth_token!
    update!(auth_token: nil)
  end
end
