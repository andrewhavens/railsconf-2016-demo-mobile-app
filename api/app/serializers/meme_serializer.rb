class MemeSerializer < ActiveModel::Serializer
  attributes :id, :image_url

  def image_url
    "/images/generated/#{object.id}.jpg"
  end
end
