class Comment < ApplicationRecord
  validates :body, presence: true
  validates :commentable, :user, :body, presence: true

  belongs_to :user
  belongs_to :commentable, polymorphic: true, optional: true, touch: true

  default_scope { order(created_at: :asc) }
end
