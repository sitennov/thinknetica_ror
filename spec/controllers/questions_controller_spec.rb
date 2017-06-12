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
                                 question: attributes_for(:question) }
        expect(assigns(:question)).to eq(question)
      end

      it 'changes question attributes' do
        patch :update, params: { id: question.id, question: new_attributes }
        question.reload

        expect(question.title).to eq(new_attributes[:title])
        expect(question.body).to eq(new_attributes[:body])
      end

      it 'redirects to show view' do
        patch :update, params: { id: question.id,
                                 question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'invalid attributes' do
      let!(:question) { create(:question) }

      it "does not chenges question attributes" do
        patch :update, params: { id: question.id,
                                 question: { title: nil, body: nil }}
        question.reload

        expect(question.title).to_not eq nil
        expect(question.body).to_not eq nil
      end

      it 'redirects to edit view' do
        patch :update, params: { id: question.id,
                                 question: attributes_for(:invalid_question) }
        expect(response).to render_template :edit
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
        expect { delete :destroy, params: { id: question } }.not_to change(Question, :count)
      end
    end
  end
end
