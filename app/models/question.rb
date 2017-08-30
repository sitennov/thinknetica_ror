class Question < ApplicationRecord
  include Votable
  include Commentable

  validates :title, :body, presence: true

  default_scope { order(:id) }

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  accepts_nested_attributes_for :attachments,
                                reject_if: :all_blank,
                                allow_destroy: true

  after_create :subscribe_author

  def subscribed?(user)
    self.subscriptions.where(user: user).exists?
  end

  private

  def find_subscription(user)
    subscriptions.where(user: user).first
  end

  def subscribe_author
    Subscription.create!(user: user, question: self)
  end
end
