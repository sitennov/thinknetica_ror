require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  sign_in_user
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:invalid_question) { create(:invalid_question) }
  let(:new_attributes) {{ title: 'newtitle', body: 'newbody' }}

  describe 'GET #index' do
    let!(:questions) { create_list(:question, 2) }
    before { get :index }

    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { user_id: user, id: question.id }}

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'assigns a new question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: { id: question.id }}

    it 'assings the requested question to @question' do
      expect(assigns(:question)).to eq(question)
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new question' do
        expect { post :create, params: { question: attributes_for(:question) }
        }.to change(@user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'not saves the new question' do
        expect {
          post :create, params: { question: attributes_for(:invalid_question) }
        }.to_not change(Question, :count)
      end

      it 'redirects to new view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context 'valid attributes' do
      it 'assings the requested question to @question' do
        patch :update, params: { id: question.id,
                                 question: attributes_for(:question),
                                 format: :js }
        expect(assigns(:question)).to eq(question)
      end

      it 'changes question attributes' do
        patch :update, params: { id: question.id,
                                 question: new_attributes,
                                 format: :js }
        question.reload

        expect(question.title).to eq question.title
        expect(question.body).to eq question.body
      end

      it 'render update template' do
        patch :update, params: { id: question.id,
                                 question: attributes_for(:question),
                                 format: :js }
        expect(response).to render_template :update
      end
    end

    context 'invalid attributes' do
      let!(:question) { create(:question) }

      it "does not chenges question attributes" do
        patch :update, params: { id: question.id,
                                 question: { title: nil, body: nil },
                                 format: :js}
        question.reload

        expect(question.title).to_not eq nil
        expect(question.body).to_not eq nil
      end

      it 'render update template' do
        patch :update, params: { id: question.id,
                                 question: attributes_for(:invalid_question),
                                 format: :js }
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'author' do
      it 'author deletes question' do
        sign_in(question.user)

        expect {
            delete :destroy, params: { id: question.id }
          }.to change(question.user.questions, :count).by(-1)
      end

      it 'redirects to questions_path' do
        sign_in(question.user)

        delete :destroy, params: { id: question.id }
        expect(response).to redirect_to questions_path
      end
    end

    context 'not the author' do
      it 'does not delete a question belonging to another user' do
        expect { delete :destroy, params: { id: question }
        }.not_to change(Question, :count)
      end
    end
  end

  # VOTES

  describe 'Author can not vote for his question' do
    sign_in_user
    let!(:question) { create(:question, user: @user) }

    context 'POST #vote_up' do
      it 'trying to vote up his question' do
        expect { post :vote_up, params: { id: question, format: :json }
          }.to change(Vote, :count).by(0)
      end
    end

    context 'POST #vote_down' do
      it 'trying to vote down his question' do
        expect { post :vote_down, params: { id: question,
                                            format: :json }
        }.to change(Vote, :count).by(0)
      end
    end
  end

  describe 'User is voting for question of somebody' do
    let!(:question) { create(:question) }
    sign_in_user

    context 'POST #vote_up' do
      it 'assigns the requested question to @votable' do
        post :vote_up, params: { id: question,
                                 question: attributes_for(:question),
                                 format: :json }
        expect(assigns(:votable)).to eq question
      end

      it 'is voting up to question (can not do it more than 1 time)' do
        post :vote_up, params: { id: question, format: :json}
        post :vote_up, params: { id: question, format: :json}
        expect(question.rating).to eq 1
      end

      it 'returns JSON parse' do
        post :vote_up, params: { id: question,
                                 question: attributes_for(:question),
                                 format: :json }
        json_parse = JSON.parse(response.body)
        expect(json_parse['rating']).to eq(1)
      end
    end

    context 'POST #vote_down' do
      it 'assigns the requested question to @votable' do
        post :vote_up, params: { id: question,
                                 question: attributes_for(:question),
                                 format: :json }
        expect(assigns(:votable)).to eq question
      end

      it 'is voting down to question (can not do it more than 1 time)' do
        post :vote_down, params: { id: question, format: :json}
        post :vote_down, params: { id: question, format: :json}
        expect(question.rating).to eq -1
      end

      it 'returns JSON parse' do
        post :vote_down, params: { id: question,
                                   question: attributes_for(:question),
                                   format: :json }
        json_parse = JSON.parse(response.body)
        expect(json_parse['rating']).to eq(-1)
      end
    end

    context 'DELETE #vote_reset' do
      it 'is voting up to question and reset his vote' do
        post :vote_up, params: { id: question.id, format: :json }
        delete :vote_reset, params: { id: question.id, format: :json }

        expect(question.rating).to eq 0
      end
    end
  end

  # COMMENTS

  describe 'POST #comment' do
    sign_in_user
    let!(:question) { create(:question) }
    let(:comment) { attributes_for(:comment) }

    context 'with valid attributes' do
      it 'added comment' do
        expect { post :comment, params: { id: question.id, comment: comment }, format: :js }
          .to change(Comment, :count).by(1)
      end

      it 'render view association show' do
        post :comment, params: { id: question.id, comment: comment }, format: :js
        expect(response).to render_template 'comment'
      end
    end

    context 'with invalid attributes' do
      it 'did not add a comment' do
        expect { post :comment, params: { id: question.id, comment: attributes_for(:invalid_comment) }, format: :js }
          .to_not change(Comment, :count)
      end
    end
  end
end

