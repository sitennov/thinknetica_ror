class AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :url, :created_at, :updated_at

  belongs_to :attachable, polymorphic: true, optional: true

  def url
    object.file.url
  end
end
