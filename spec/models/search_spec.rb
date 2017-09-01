require 'rails_helper'

RSpec.describe Search, type: :model do
  describe 'search result' do
    %w(All '').each do |attr|
      it "gets condition #{attr}" do
        expect(ThinkingSphinx).to receive(:search).with('something')
        Search.search_result('something', attr)
      end
    end

    %w(Questions Answers Comments Users).each do |attr|
      it "gets condition: #{attr}" do
        expect(attr.singularize.classify.constantize).to receive(:search).with('something')
        Search.search_result('something', attr)
      end
    end
  end
end
