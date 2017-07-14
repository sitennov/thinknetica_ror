module Votabled
  extend ActiveSupport::Concern

  included do
    before_action :load_votable, only: [:vote_up]
  end

  def vote_up
    @votable.vote_up(current_user)
    respond_to do |format|
      format.json { render json: {@votable.class.name.downcase, object_id: @votable.id, count: @votable.vote_rating}.to_json }
    end
  end

  private

  def load_votable
    p model_klass
    # @votable = model_klass.find(params[:id])
  end
end
