require 'rails_helper'

RSpec.describe Subscription, type: :model do
  let(:user){ create(:user) }
  let(:other_user){ create(:user) }
  let(:question){ create(:question, user: user) }
  let!(:subscription){ create(:subscription, user: other_user, question: question) }

  it { should validate_uniqueness_of(:question_id).scoped_to(:user_id) }

  it { should belong_to :user }
  it { should belong_to :question }
end
