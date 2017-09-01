shared_examples_for "votabled" do
  describe 'Author can not vote for his answer/question' do
    sign_in_user
    let!(:votable) { create(item, user: @user) }

    context 'POST #vote_up' do
      it 'trying to vote up his answer' do
        expect { post :vote_up, params: { id: votable, format: :json }
          }.to change(Vote, :count).by(0)
      end
    end

    context 'POST #vote_down' do
      it 'trying to vote down his answer' do
        expect { post :vote_down, params: { id: votable, format: :json }
          }.to change(Vote, :count).by(0)
      end
    end
  end

  describe 'User is voting for answer/question of somebody' do
    sign_in_user
    let!(:votable) { create(item) }

    context 'POST #vote_up' do
      it 'is voting up to answer (can not do it more than 1 time)' do
        expect { post :vote_up, params: { id: votable, format: :json }
          }.to change(Vote, :count).by(1)

        expect { post :vote_up, params: { id: votable, format: :json }
          }.to_not change(Vote, :count)
      end

      it 'returns JSON parse' do
        post :vote_up, params: { id: votable, format: :json }
        json_parse = JSON.parse(response.body)
        expect(json_parse['rating']).to eq(1)
      end
    end

    context 'DELETE #vote_reset' do
      let!(:voted) { create(:vote, votable: votable, user: @user) }

      it 'is voting up to answer and reset his vote' do
        expect { delete :vote_reset, params: { id: votable, format: :json }
          }.to change(Vote, :count).by(-1)
      end
    end
  end
end
