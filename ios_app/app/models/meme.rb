class Meme
  attr_accessor :id, :image_url

  def initialize(data)
    @id = data["id"]
    @image_url = "http://localhost:3000" + data["image_url"]
  end

  def self.all(&callback)
    ApiClient.client.get "memes" do |response|
      models = []
      if response.success?
        models = response.object.map {|data| new(data) }
      end
      callback.call(response, models)
    end
  end

  def self.create(data, &callback)
    ApiClient.client.post "memes", meme: data do |response|
      model = nil
      if response.success?
        model = new(response.object)
      end
      callback.call(response, model)
    end
  end
end
