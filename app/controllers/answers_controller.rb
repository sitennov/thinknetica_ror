class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :get_question, only: [:create]
  before_action :get_answer, only: [:edit, :update, :destroy]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to @question, notice: t('.created')
    else
      render :new
    end
  end

  def destroy
    @question = @answer.question
    if @answer.user = current_user
      @answer.destroy
      redirect_to @question, notice: t('.deleted')
    else
      render 'questions/show'
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
