require 'rails_helper'

RSpec.describe NotifySubscribersJob, type: :job do
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }
  let!(:subscription) { create(:subscription, question: question) }

  it 'notify subscribers' do
    question.subscriptions.each do |subscription|
      expect(AnswerMailer).to receive(:notify).with(subscription).and_call_original
    end
    NotifySubscribersJob.perform_now(question)
  end
end
