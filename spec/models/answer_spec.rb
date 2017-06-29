require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of(:body) }

  it { should belong_to(:question) }
  it { should belong_to(:user) }
end
