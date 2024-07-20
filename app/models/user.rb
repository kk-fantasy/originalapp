class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :reviews
  has_many :likes, dependent: :destroy
  has_many :liked_reviews, through: :likes, source: :review
  has_many :authentications, dependent: :destroy

  accepts_nested_attributes_for :authentications

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
    if save
      logger.debug "Password successfully updated for user: #{self.email}"
      true
    else
      logger.debug "Failed to update password for user: #{self.email} - Errors: #{self.errors.full_messages}"
      false
    end
  end

  def likes?(review)
    self.likes.exists?(review_id: review.id)
  end

  def self.from_omniauth(auth)
    authentication = Authentication.find_by(provider: auth['provider'], uid: auth['uid'])
    if authentication
      return authentication.user
    else
      user = User.find_or_create_by(email: auth['info']['email']) do |u|
        u.first_name = auth['info']['first_name'] || auth['info']['name'].split.first
        u.last_name = auth['info']['last_name'] || auth['info']['name'].split.last
        u.password = SecureRandom.hex(10)
      end
      user.authentications.create(provider: auth['provider'], uid: auth['uid'])
      return user
    end
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
