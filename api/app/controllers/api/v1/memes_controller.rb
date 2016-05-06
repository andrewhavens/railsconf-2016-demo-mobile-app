class Api::V1::MemesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_meme, only: [:show, :update, :destroy]

  def index
    memes = current_user.memes.order(created_at: :desc)
    render json: memes
  end

  def create
    meme = current_user.memes.new(meme_params)
    if meme.save
      render json: meme, status: :created
    else
      render json: meme.errors, status: :unprocessable_entity
    end
  end

  def update
    if @meme.update(meme_params)
      render json: @meme, status: :ok
    else
      render json: @meme.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @meme.destroy
    head :no_content
  end

  private
    def set_meme
      @meme = current_user.memes.find(params[:id])
    end

    def meme_params
      params.require(:meme).permit(:top_text, :bottom_text, :meme_template_id)
    end
end
