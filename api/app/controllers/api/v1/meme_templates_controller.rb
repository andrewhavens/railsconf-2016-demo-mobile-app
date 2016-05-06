class Api::V1::MemeTemplatesController < ApplicationController
  def index
    meme_templates = MemeTemplate.all
    render json: meme_templates
  end
end
