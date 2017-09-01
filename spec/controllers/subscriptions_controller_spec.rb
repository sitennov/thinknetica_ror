require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do

  describe 'POST #create' do
    let!(:question) { create(:question) }
    let!(:user) { create(:user) }

    before { sign_in user }

    it 'creates subscription to a question' do
      expect { post :create, params: { subscription: { question_id: question }, format: :js } }.to change(user.subscriptions, :count).by(1)
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscription) { create(:subscription) }

    it 'deletes subscription to a question' do
      sign_in(subscription.user)

      expect { delete :destroy, params: { id: subscription, format: :js } }.to change(Subscription, :count).by(-1)
    end
  end
end
