require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }
  let(:invalid_answer) { create(:invalid_answer) }

  describe  'POST #create' do
    context 'with valid attributes' do
      it 'saves the new answer' do
        expect do
          post :create, params: { question_id: question.id,
                                  answer: attributes_for(:answer) }
        end.to change(question.answers, :count).by(1)
      end

      it 'redirects to question show view' do
        post :create, params: { question_id: question.id,
                                answer: attributes_for(:answer) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'not saves the new answer' do
        expect do
          post :create, params: { question_id: question.id,
                                  answer: attributes_for(:invalid_answer) }
        end.to_not change(Answer, :count)
      end

      it 'redirects to question show view' do
        post :create, params: { question_id: question.id,
                                answer: attributes_for(:invalid_answer) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end
  end
end
