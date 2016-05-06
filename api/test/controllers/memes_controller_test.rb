require 'test_helper'

class MemesControllerTest < ActionController::TestCase
  setup do
    @meme = memes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:memes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create meme" do
    assert_difference('Meme.count') do
      post :create, meme: { meme_template_id: @meme.meme_template_id, text: @meme.text }
    end

    assert_redirected_to meme_path(assigns(:meme))
  end

  test "should show meme" do
    get :show, id: @meme
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @meme
    assert_response :success
  end

  test "should update meme" do
    patch :update, id: @meme, meme: { meme_template_id: @meme.meme_template_id, text: @meme.text }
    assert_redirected_to meme_path(assigns(:meme))
  end

  test "should destroy meme" do
    assert_difference('Meme.count', -1) do
      delete :destroy, id: @meme
    end

    assert_redirected_to memes_path
  end
end
