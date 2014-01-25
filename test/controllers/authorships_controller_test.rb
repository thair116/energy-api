require 'test_helper'

class AuthorshipsControllerTest < ActionController::TestCase
  setup do
    @authorship = authorships(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:authorships)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create authorship" do
    assert_difference('Authorship.count') do
      post :create, authorship: { article_id: @authorship.article_id, author_id: @authorship.author_id }
    end

    assert_redirected_to authorship_path(assigns(:authorship))
  end

  test "should show authorship" do
    get :show, id: @authorship
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @authorship
    assert_response :success
  end

  test "should update authorship" do
    patch :update, id: @authorship, authorship: { article_id: @authorship.article_id, author_id: @authorship.author_id }
    assert_redirected_to authorship_path(assigns(:authorship))
  end

  test "should destroy authorship" do
    assert_difference('Authorship.count', -1) do
      delete :destroy, id: @authorship
    end

    assert_redirected_to authorships_path
  end
end
