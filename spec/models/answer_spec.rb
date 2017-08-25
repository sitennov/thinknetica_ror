require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of(:body) }

  it { should have_many :attachments }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should accept_nested_attributes_for :attachments }

  describe 'Set best' do
    let!(:object) { create(:answer) }
    let(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    let(:answers) { create_list(:answer, 3, question: question) }

    it 'set best answer' do
      answer.set_best
      expect(answer.best).to eq true
    end

    it 'best answer is first' do
      answer.set_best

      expect(Answer.first).to eq answer
    end

    it 'only one answer can be best' do
      answer.set_best

      Answer.where.not(id: answer).each do |answer|
        expect(answer.best).to eq false
      end
    end
  end
end
