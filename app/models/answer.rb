class Answer < ApplicationRecord
  validates :body, presence: true

  belongs_to :user
  belongs_to :question

  has_many :attachments, as: :attachable, dependent: :destroy

  default_scope { order(best: :desc, created_at: :asc) }

  accepts_nested_attributes_for :attachments

  def set_best!
    Answer.transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
