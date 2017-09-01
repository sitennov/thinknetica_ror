require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #search' do
    %w(All Questions Answers Comments Users).each do |attr|
      it "gets condition: #{attr}" do
        expect(Search).to receive(:search_result).with('question', attr)

        get :search, params: { query: 'question', condition: attr }
        expect(response).to render_template :search
      end
    end
  end
end
