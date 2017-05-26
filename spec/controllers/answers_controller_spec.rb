require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }
  let(:invalid_answer) { create(:invalid_answer) }

  describe "GET #new" do
    sign_in_user

    before { get :new, params: { question_id: question } }

    it "assigns a new answer to @answer" do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it "render new view" do
      expect(response).to render_template :new
    end
  end

  describe "GET #index" do
    let(:answers) { create_list(:answer, 2, question: question) }

    before { get :index, params: { question_id: question.id }}

    it "array of all answers to question" do
      expect(assigns(:answers)).to match_array(answers)
    end

    it "render index view" do
      expect(response).to render_template :index
    end
  end

  describe  'POST #create' do
    sign_in_user

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
        expect(response).to redirect_to question_answers_path(assigns(:question))
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
end
