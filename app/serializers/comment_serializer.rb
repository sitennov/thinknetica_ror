class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :user_id, :created_at, :updated_at

  belongs_to :commentable, polymorphic: true, optional: true
end
