require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author_of?' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, user: user) }

    it 'should return true if the user is the owner of the question' do
      expect(user.author_of?(question)).to eq true
    end

    it 'should return false if the user is not the owner of the question' do
      expect(other_user.author_of?(question)).to eq false
    end

    it 'should return true if the user is the owner of the answer' do
      expect(user.author_of?(answer)).to eq true
    end

    it 'should return false if the user is not the owner of the answer' do
      expect(other_user.author_of?(answer)).to eq false
    end
  end
end
