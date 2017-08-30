require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :profile }
    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all}
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }
    let(:question) { create(:question, user: user) }
    let(:other_question) { create(:question, user: other) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }
    it { should be_able_to :manage, :profile }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }
    it { should be_able_to :create, Attachment }
    it { should be_able_to :create, Subscription,  user: user }
    it { should be_able_to :destroy, Subscription, user: user }

    it { should be_able_to :update, create(:question, user: user), user: user }
    it { should_not be_able_to :update, create(:question, user: other), user: user }

    it { should be_able_to :update, create(:answer, user: user), user: user }
    it { should_not be_able_to :update, create(:answer, user: other), user: user }

    it { should be_able_to :update, question, user: user }
    it { should_not be_able_to :update, other_question, user: user }

    it { should be_able_to :update, create(:answer, user: user), user: user }
    it { should_not be_able_to :update, create(:answer, user: other), user: user }

    it { should be_able_to :set_best, create(:answer, question: question), user: user }
    it { should_not be_able_to :set_best, create(:answer, question: other_question), user: user }

    it { should be_able_to :destroy, create(:answer, user: user), user: user }
    it { should_not be_able_to :destroy, create(:answer, user: other), user: user }

    it { should be_able_to :destroy, question, user: user }
    it { should_not be_able_to :destroy, other_question, user: user }

    it { should be_able_to :destroy, create(:attachment, attachable: question) }
    it { should_not be_able_to :destroy, create(:attachment, attachable: other_question) }
  end
end
