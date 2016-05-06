class MemeTemplate
  attr_accessor :id, :name, :image_url, :width, :height, :ratio

  def initialize(data)
    @id = data["id"]
    @name = data["name"]
    @image_url = "http://localhost:3000" + data["image_url"]
    @width = data["width"]
    @height = data["height"]
    @ratio = data["ratio"]
  end

  def self.all(&callback)
    ApiClient.client.get "meme_templates" do |response|
      models = nil
      if response.success?
        models = response.object.map do |data|
          new(data)
        end
      end
      callback.call(response, models)
    end
  end
end
