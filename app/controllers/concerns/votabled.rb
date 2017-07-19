module Votabled
  extend ActiveSupport::Concern

  included do
    before_action :load_votable, only: [:vote_up, :vote_down, :vote_reset]
  end

  def vote_up
    if user_not_author
      @votable.vote_up(current_user)
      respond_to_json
    end
  end

  def vote_down
    if user_not_author
      @votable.vote_down(current_user)
      respond_to_json
    end
  end

  def vote_reset
    @votable.vote_reset(current_user)
    respond_to_json
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def load_votable
    @votable = model_klass.find(params[:id])
  end

  def user_not_author
    !current_user.author_of?(@votable)
  end

  def respond_to_json
    if @votable.class == Answer
      respond_to do |format|
        format.json { render json: {class: 'answer', question_id: @votable.question.id, id: @votable.id, rating: @votable.rating}.to_json }
      end
    elsif @votable.class == Question
      respond_to do |format|
        format.json { render json: {class: 'question', id: @votable.id, answer_id: nil, rating: @votable.rating}.to_json }
      end
    end
  end
end
