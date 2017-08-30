class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_subscription, only: [:destroy]

  authorize_resource

  respond_to :js

  def create
    # @subscription = current_user.subscriptions.create!(subscription_params)
    respond_with(@subscription = Subscription.create(subscription_params.merge(user: current_user)))
  end

  def destroy
    @subscription.destroy
    @question = @subscription.question
  end

  private

  def load_subscription
    @subscription = Subscription.find(params[:id])
  end

  def subscription_params
    params.require(:subscription).permit(:question_id)
  end
end
