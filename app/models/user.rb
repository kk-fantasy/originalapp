class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :reviews

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :first_name, presence: true, length: { maximum: 255 }
  validates :last_name, presence: true, length: { maximum: 255 }

  validates :reset_password_token, uniqueness: true, allow_nil: true, if: -> { reset_password_token.present? }

  def name
    "#{first_name} #{last_name}"
  end

  def reset_password_instructions!
    generate_reset_password_token!
    send_reset_password_email
  end

  def change_password(new_password)
    self.password = new_password
    save!
  end

  private

  def generate_reset_password_token!
    self.reset_password_token = SecureRandom.urlsafe_base64
    self.reset_password_token_expires_at = Time.current + 1.hour
    save!
  end

  def send_reset_password_email
    UserMailer.reset_password_email(self).deliver_now
  end
end