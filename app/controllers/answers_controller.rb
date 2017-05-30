class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :get_question, only: [:index, :create, :new]
  before_action :get_answer, only: [:show, :edit, :update, :destroy]

  def index
    @answers = @question.answers
  end

  def show
  end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.create(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to question_answers_path(@question), notice: 'Your answer successfully created'
    else
      render :new
    end
  end

  def destroy
    @question = @answer.question
    if current_user.id == @answer.user.id
      @answer.destroy
      redirect_to @question, notice: 'Answer successfully deleted'
    else
      redirect_to @question, notice: 'You cant delete this answer'
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
