require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many :attachments }

  it { should belong_to(:user) }

  it { should accept_nested_attributes_for :attachments }

  describe 'Ability subscription' do
    let(:question){ build(:question) }

    it 'calls subscribe author after create' do
      expect(question).to receive(:subscribe_author)
      question.save
    end

    it 'creates subscription for author after question creation' do
      expect(Subscription).to receive(:create!).with(user: question.user, question: question)

      question.save
    end
  end
end
