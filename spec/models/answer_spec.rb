require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of(:body) }
  it { should have_many :attachments }
  it { should have_many(:votes).dependent(:destroy) }

  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should accept_nested_attributes_for :attachments }
end
