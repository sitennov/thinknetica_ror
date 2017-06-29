class Question < ApplicationRecord
  validates :title, :body, presence: true

  default_scope { order(:id) }

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
end
