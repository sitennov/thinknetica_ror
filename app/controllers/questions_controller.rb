class QuestionsController < ApplicationController
  include Votabled
  include Commentabled

  before_action :authenticate_user!, except: [:index, :show]
  before_action :get_question, only: [:show, :edit, :update, :destroy]

  after_action :publish_question, only: [:create]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
    @answer.attachments.build
    gon.question_id = @question.id
    gon.question_user_id = @question.user_id
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def edit
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      redirect_to question_path(@question), notice: t('.created')
    else
      render :new
    end
  end

  def update
    if current_user.id == @question.user_id
      if @question.update(question_params)
        flash[:notice] = t('.edited')
        redirect_to @question
      end
    end
  end

  def destroy
    if @question.user_id = current_user.id
      @question.destroy
      redirect_to questions_path, notice: t('.deleted')
    else
      redirect_to root_path, notice: t('.not_deleted')
    end
  end

  private

  def get_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
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
