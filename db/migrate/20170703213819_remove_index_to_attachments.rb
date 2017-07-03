class RemoveIndexToAttachments < ActiveRecord::Migration[5.1]
  def change
    remove_index :attachments, :attachable_id
    remove_index :attachments, :attachable_type
  end
end
