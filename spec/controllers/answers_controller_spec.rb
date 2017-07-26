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
      patch :update, params: { id: answer,
                               answer: attributes_for(:answer)},
                               format: :js
      expect(assigns(:answer)).to eq answer
    end

    it 'assigns the question' do
      patch :update, params: { id: answer,
                               question_id: question,
                               answer: attributes_for(:answer) },
                               format: :js
      expect(assigns(:question)).to eq question
    end

    it 'render update template' do
      patch :update, params: { id: answer,
                               answer: attributes_for(:answer)},
                               format: :js
      expect(response).to render_template :update
    end
  end

  describe 'DELETE #destroy' do
    context 'Delete user answer' do
      let!(:answer) { create(:answer, question: question, user: @user) }

      it 'user delete answer' do
        expect { delete :destroy, params: { question_id: question.id,
                                            id: answer },
                                            format: :js
        }.to change(Answer, :count).by(-1)
      end
    end

    context 'User deletes answer another user' do
      let!(:other_user) { create(:user) }

      it 'user delete answer' do
        sign_in(other_user)

        expect { delete :destroy, params: { question_id: question.id,
                                            id: answer },
                                            format: :js
        }.to_not change(Answer, :count)
      end
    end
  end

  # VOTES

  describe 'Author can not vote for his answer' do
    sign_in_user
    let!(:answer) { create(:answer, question: question, user: @user) }

    context 'POST #vote_up' do
      it 'trying to vote up his answer' do
        expect { post :vote_up, params: { id: answer,
                                          question_id: question.id,
                                          format: :json }
        }.to change(Vote, :count).by(0)
      end
    end

    context 'POST #vote_down' do
      it 'trying to vote down his answer' do
        expect { post :vote_down, params: { id: answer,
                                            question_id: question.id,
                                            format: :json }
        }.to change(Vote, :count).by(0)
      end
    end
  end

  describe 'User is voting for answer of somebody' do
    sign_in_user
    let!(:answer) { create(:answer, question: question) }

    context 'POST #vote_up' do
      it 'assigns the requested answer to @votable' do
        post :vote_up, params: { id: answer,
                                 question_id: question.id,
                                 answer: attributes_for(:answer),
                                 format: :json }
        expect(assigns(:votable)).to eq answer
      end

      it 'is voting up to answer (can not do it more than 1 time)' do
        post :vote_up, params: { id: answer,
                                 question_id: question.id,
                                 format: :json}
        post :vote_up, params: { id: answer,
                                 question_id: question.id,
                                 format: :json}
        expect(answer.rating).to eq 1
      end

      it 'returns JSON parse' do
        post :vote_up, params: { id: answer,
                                 question_id: question.id,
                                 answer: attributes_for(:answer),
                                 format: :json }
        json_parse = JSON.parse(response.body)
        expect(json_parse['rating']).to eq(1)
      end
    end

    context 'DELETE #vote_reset' do
      it 'is voting up to answer and reset his vote' do
        post :vote_up, params: { id: answer,
                                 question_id: question.id,
                                 format: :json }
        delete :vote_reset, params: { id: answer,
                                      question_id: question.id,
                                      format: :json }
        expect(answer.rating).to eq 0
      end
    end
  end

  # COMMENTS

  describe 'POST #comment' do
    sign_in_user
    let!(:answer) { create(:answer) }
    let(:comment) { attributes_for(:comment) }

    context 'with valid attributes' do
      it 'added commet' do
        expect { post :comment, params: { id: answer, comment: comment }, format: :js }
          .to change(Comment, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'did not add a comment' do
        expect { post :comment, params: { id: answer, comment: attributes_for(:invalid_comment) }, format: :js }
          .to_not change(Comment, :count)
      end
    end
  end
end
