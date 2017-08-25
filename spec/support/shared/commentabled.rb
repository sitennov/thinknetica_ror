shared_examples_for "commentabled" do
  describe 'POST #comment' do
    sign_in_user
    let!(:association) { create(item) }
    let(:comment) { attributes_for(:comment) }

    context 'with valid attributes' do
      it 'added commet' do
        expect { post :comment, params: { id: association,
                                          comment: comment },
                                          format: :js
          }.to change(Comment, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'did not add a comment' do
        expect { post :comment, params: { id: association,
                                          comment: attributes_for(:invalid_comment) },
                                          format: :js
          }.to_not change(Comment, :count)
      end
    end
  end
end
