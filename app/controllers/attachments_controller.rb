class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_attachment

  def destroy
    if current_user.author_of?(@attachment.attachable)
      @attachment.destroy
    else
      flash[:notice] = 'error delete attachment'
    end
  end

  private

  def get_attachment
    @attachment = Attachment.find(params[:id])
  end
end
