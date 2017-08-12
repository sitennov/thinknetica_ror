class Answer < ApplicationRecord
  include Votable
  include Commentable

  validates :body, presence: true

  belongs_to :user
  belongs_to :question

  has_many :attachments, as: :attachable, dependent: :destroy

  accepts_nested_attributes_for :attachments,
                                reject_if: :all_blank,
                                allow_destroy: true

  default_scope { order(best: :desc, created_at: :asc) }

  def set_best
    Answer.transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
