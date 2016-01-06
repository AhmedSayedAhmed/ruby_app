require 'test_helper'

class TxtFilesControllerTest < ActionController::TestCase
  setup do
    @txt_file = txt_files(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:txt_files)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create txt_file" do
    assert_difference('TxtFile.count') do
      post :create, txt_file: { name: @txt_file.name, path: @txt_file.path }
    end

    assert_redirected_to txt_file_path(assigns(:txt_file))
  end

  test "should show txt_file" do
    get :show, id: @txt_file
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @txt_file
    assert_response :success
  end

  test "should update txt_file" do
    patch :update, id: @txt_file, txt_file: { name: @txt_file.name, path: @txt_file.path }
    assert_redirected_to txt_file_path(assigns(:txt_file))
  end

  test "should destroy txt_file" do
    assert_difference('TxtFile.count', -1) do
      delete :destroy, id: @txt_file
    end

    assert_redirected_to txt_files_path
  end
end
