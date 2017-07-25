class CommentsController < ApplicationController
  before_action :authenticate_user!

  def load_commentable
    @commentable = params[:comment][:commentable_type].constantize.find(params[:comment][:commentable_id])
  end
end
