class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :get_question, only: [:create]
  before_action :get_answer, only: [:destroy]

  def create
    @answer = @question.answers.create(answer_params)
    @answer.user_id = current_user.id
    @answer.save
  end

  def destroy
    @question = @answer.question
    if @answer.user_id = current_user.id
      @answer.destroy
    end
  end

  private

  def get_question
    @question = Question.find(params[:question_id])
  end

  def get_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
