class QuestionsController < ApplicationController
  include Votabled
  include Commentabled

  before_action :authenticate_user!, except: [:index, :show]
  before_action :get_question, only: [:show, :edit, :update, :destroy]
  before_action :build_answer, only: [:show]
  after_action :publish_question, only: [:create]

  authorize_resource

  respond_to :js, only: [:show, :update]

  def index
    respond_with(@questions = Question.all)
  end

  def show
    gon.question_id = @question.id
    gon.question_user_id = @question.user_id
    @subscription = @question.subscriptions.find_by(user_id: current_user.id) if current_user
    respond_with(@question)
  end

  def new
    respond_with(@question = Question.new)
  end

  def edit
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    @question.update(question_params)
    respond_with(@question)
  end

  def destroy
    respond_with(@question.destroy!)
  end

  private

  def get_question
    @question = Question.find(params[:id])
  end

  def build_answer
    @answer = @question.answers.build
  end

  def question_params
    params.require(:question).permit(:title,
                                     :body,
                                     attachments_attributes: [:id,
                                                              :file,
                                                              :_destroy])
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question',
        locals: { question: @question }
      )
    )
  end
end
