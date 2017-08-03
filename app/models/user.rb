class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :twitter]
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  def author_of?(entity)
    id == entity.user_id
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.find_by(provider: auth.provider,
                                          uid: auth.uid.to_s)
    return authorization.user if authorization
    return unless auth.info && auth.info[:email]

    email = auth.info[:email]
    user = User.find_by(email: email)

    unless user
      password = Devise.friendly_token[0, 20]
      user = User.new(email: email,
                      password: password,
                      password_confirmation: password)
      user.skip_confirmation!
      user.save!
      user.create_authorization(auth)
    end
    user.create_authorization(auth)
    user
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider,
                               uid: auth.uid)
  end
end
