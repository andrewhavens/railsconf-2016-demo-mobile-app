class MemeTemplateSerializer < ActiveModel::Serializer
  attributes :id, :name, :image_url, :width, :height, :ratio

  def image_url
    "/images/#{object.file_name}"
  end

  def ratio
    object.width.to_f / object.height.to_f
  end
end
