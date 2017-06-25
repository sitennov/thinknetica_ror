class Answer < ApplicationRecord
  validates :body, presence: true

  belongs_to :user
  belongs_to :question

  default_scope { order(best: :desc, created_at: :asc) }

  def set_best!
    Answer.transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
