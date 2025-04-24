require "test_helper"

class BookshelvesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bookshelf = bookshelves(:one)
    @other_bookshelf = bookshelves(:two)
    @user = users(:one)
  end

  test "should get index" do
    get bookshelves_path
    assert_response :success
  end

  test "should get new" do
    post session_path, params: { email_address: @user.email_address, password: "password" }
    assert_equal @user.id, session[:user_id]
    get new_bookshelf_path
    assert_response :success
  end

  test "should create bookshelf" do
    post session_path, params: { email_address: @user.email_address, password: "password" }
    assert_equal @user.id, session[:user_id]
    assert_difference("Bookshelf.count") do
      post bookshelves_path, params: { bookshelf: { name: "Lets go", isbn: "9780618346257" } }
    end

    assert_redirected_to bookshelf_path(Bookshelf.last)
  end

  test "should show bookshelf" do
    get bookshelf_path(@bookshelf)
    assert_response :success
  end

  test "should get edit" do
    post session_path, params: { email_address: @user.email_address, password: "password" }
    assert_equal @user.id, session[:user_id]
    get edit_bookshelf_path(@bookshelf)
    assert_response :success
  end

  test "should update bookshelf" do
    post session_path, params: { email_address: @user.email_address, password: "password" }
    assert_equal @user.id, session[:user_id]
    patch bookshelf_path(@bookshelf), params: { bookshelf: { name: "Letsgo" } }
    assert_redirected_to bookshelf_path(@bookshelf)
  end

  test "should destroy bookshelf" do
    post session_path, params: { email_address: @user.email_address, password: "password" }
    assert_equal @user.id, session[:user_id]
    assert_difference("Bookshelf.count", -1) do
      delete bookshelf_path(@bookshelf)
    end

    assert_redirected_to bookshelves_path
  end
end
