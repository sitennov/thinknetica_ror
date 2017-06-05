require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user

  let(:question) { create(:question) }
  let(:answer) { create(:answer) }
  let(:invalid_answer) { create(:invalid_answer) }
  let(:other_user) { create(:user) }

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
                                answer: attributes_for(:answer).except(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'not saves the new answer' do
        expect do
          post :create, params: { question_id: question.id,
                                  answer: attributes_for(:invalid_answer) }
        end.to_not change(question.answers, :count)
      end

      it 'redirects to question show view' do
        post :create, params: { question_id: question.id,
                                answer: attributes_for(:invalid_answer) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Delete user answer' do
      let!(:answer) { create(:answer, question: question, user: @user) }

      it 'user delete answer' do
        expect { delete :destroy, params: { question_id: question.id,
                                            id: answer }
        }.to change(Answer, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, params: { question_id: question.id, id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'User deletes answer another user' do
      let!(:other_user) { create(:user) }

      it 'user delete answer' do
        sign_in(other_user)

        expect { delete :destroy, params: { question_id: question.id, id: answer }}
        .to_not change(Answer, :count)
      end
    end
  end
end
