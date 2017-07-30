module Commentabled
  extend ActiveSupport::Concern

  included do
    before_action :load_commentable, only: :comment
    after_action :publish_comment, only: :comment
  end

  def comment
    @comment = @association.comments.new(comment_params)
    @comment.user_id = current_user.id
    @comment.save
  end

  private

  def load_commentable
    @association = model_klass.find(params[:id])
    if @association.class.name == 'Question'
      @question_id = @association.id
    elsif @association.class.name == 'Answer'
      @question_id = @association.question.id
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?
    ActionCable.server.broadcast(
      "questions/#{@question_id}/comments",
      ApplicationController.render(
        partial: 'questions/comment',
        formats: :json,
        locals: { comment: @comment }
      )
    )
  end
end
