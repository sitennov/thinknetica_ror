class AnswersController < ApplicationController
  include Votabled
  include Commentabled

  before_action :authenticate_user!
  before_action :get_question, only: [:create]
  before_action :get_answer, only: [:update, :destroy, :set_best]
  after_action :publish_answer, only: [:create]

  respond_to :js
  respond_to :json, only: :create

  def create
    @answer = @question.answers.create(answer_params.merge(user_id: current_user.id))
  end

  def update
    if current_user.author_of?(@answer)
      respond_with(@answer.update(answer_params))
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      respond_with(@answer.destroy)
    end
  end

  def set_best
    if current_user.author_of?(@answer.question)
      @answer.set_best!
    end
  end

  private

  def get_question
    @question = Question.find(params[:question_id])
  end

  def get_answer
    @answer = Answer.find(params[:id])
    @question = @answer.question
  end

  def answer_params
    params.require(:answer).permit(:body,
                                   attachments_attributes: [:file,
                                                            :id,
                                                            :_destroy])
  end

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast(
        "questions/#{@question.id}/answers",
        ApplicationController.render(
            partial: "answers/answer",
            formats: :json,
            locals: { answer: @answer }
        )
    )
  end
end
