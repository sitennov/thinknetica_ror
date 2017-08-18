class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :question_id, :user_id, :best

  has_many :comments, as: :commentable
  has_many :attachments, as: :attachable
end
