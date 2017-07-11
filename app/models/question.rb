class Question < ApplicationRecord
  include Votable

  validates :title, :body, presence: true

  default_scope { order(:id) }

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy

  accepts_nested_attributes_for :attachments,
                                reject_if: :all_blank,
                                allow_destroy: true
end
