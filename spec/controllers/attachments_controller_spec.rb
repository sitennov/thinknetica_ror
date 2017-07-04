require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  sign_in_user

  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question, user: @user) }
  let!(:attachment) { create(:attachment, attachable: answer) }

  describe 'DELETE #destroy' do
    context 'Delete user attachment' do
      it 'deletes attach of author' do
        expect{ delete :destroy, params: { attachable: answer,
                                           id: attachment,
                                           format: :js } }
        .to change(Attachment, :count).by(-1)
      end
    end

    context 'User deletes attachment another user' do
      let!(:other_user) { create(:user) }

      it 'not deletes attach of somebody' do
        sign_in(other_user)

        expect { delete :destroy, params: { attachable: answer,
                                            id: attachment,
                                            format: :js } }
        .to change(Attachment, :count).by(0)
      end
    end
  end
end
