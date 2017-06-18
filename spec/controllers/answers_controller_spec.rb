require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user

  let!(:question) { create(:question) }
  let(:answer) { create(:answer) }
  let(:invalid_answer) { create(:invalid_answer) }
  let(:other_user) { create(:user) }

  describe  'POST #create' do
    context 'with valid attributes' do
      it 'saves the new answer' do
        expect do
          post :create, params: { question_id: question.id,
                                  answer: attributes_for(:answer),
                                  format: :js }
        end.to change(question.answers, :count).by(1)
      end

      it 'render create template' do
        post :create, params: { question_id: question.id,
                                answer: attributes_for(:answer).except(:question),
                                format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'not saves the new answer' do
        expect do
          post :create, params: { question_id: question.id,
                                  answer: attributes_for(:invalid_answer),
                                  format: :js }
        end.to_not change(question.answers, :count)
      end

      it 'render create template' do
        post :create, params: { question_id: question.id,
                                answer: attributes_for(:invalid_answer),
                                format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    let(:answer) { create(:answer, question: question) }

    it 'assings the requested answer to @answer' do
      patch :update, params: { id: answer, answer: attributes_for(:answer)}, format: :js
      expect(assigns(:answer)).to eq answer
    end

    it 'assigns the question' do
      patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer) }, format: :js
      expect(assigns(:question)).to eq question
    end

    it 'render update template' do
      patch :update, params: { id: answer, answer: attributes_for(:answer)}, format: :js
      expect(response).to render_template :update
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
