require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:invalid_question) { create(:invalid_question) }
  let(:new_attributes) {{ title: 'newtitle', body: 'newbody' }}

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates an array of all quetions' do
      expect(assigns(:questions)).to match_array(@questions)
    end

    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question.id }}

    it 'assings the requested question to @question' do
      expect(assigns(:question)).to eq(question)
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
        expect do
          post :create, params: { question: attributes_for(:question) }
        end.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'not saves the new question' do
        expect do
          post :create, params: { question: attributes_for(:invalid_question) }
        end.to_not change(Question, :count)
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
      it 'question to not changed' do
        patch :update, params: { id: question.id,
                                 question: attributes_for(:invalid_question) }
        question.reload
        expect(question.title).to eq('MyString')
        expect(question.body).to eq('MyText')
      end

      it 'redirects to edit view' do
        patch :update, params: { id: question.id,
                                 question: attributes_for(:invalid_question) }
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes question' do
      question
      expect { delete :destroy, params: { id: question.id }}.to change(Question, :count).by(-1)
    end

    it 'redirects to questions_path' do
      delete :destroy, params: { id: question.id }
      expect(response).to redirect_to questions_path
    end
  end
end
