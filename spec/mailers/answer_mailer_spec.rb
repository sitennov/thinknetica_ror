require "rails_helper"

RSpec.describe AnswerMailer, type: :mailer do
  describe 'notify' do
    let!(:subscription) { create(:subscription) }
    let(:mail) { AnswerMailer.notify(subscription) }

    it "renders the headers" do
      expect(mail.subject).to eq("New answer")
      expect(mail.to).to eq([subscription.user.email])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match('To your question added a new answer')
      expect(mail.body.encoded).to match(subscription.question.title)
      expect(mail.body.encoded).to match(question_path(subscription.question))
    end
  end
end
