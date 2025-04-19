require "test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @book = books(:one)
    @other_book = books(:two)
    @user = users(:one)
    @admin = users(:two)
  end

  test "should get index" do
    get books_path
    assert_response :success
  end

  test "should get new" do
    post session_path, params: { email_address: @admin.email_address, password: "password" }
    assert_equal @admin.id, session[:user_id]

    get new_book_path
    assert_response :success
  end

  test "should create book" do
    post session_path, params: { email_address: @admin.email_address, password: "password" }
    assert_equal @admin.id, session[:user_id]

    assert_difference("Book.count") do
      post books_path, params: { book: { title: "The Hobbit", isbn: "9780547928227" } }
    end

    assert_redirected_to book_path(Book.last)
  end

  test "should show book" do
    get book_path(@book)
    assert_response :success
  end

  test "should get edit" do
    get edit_book_path(@book)
    assert_response :unauthorized
  end

  # test "should update book" do
  #   patch book_path(@book), params: { book: { isbn: @book.isbn } }
  #   assert_redirected_to book_path(@book)
  # end

  # test "should destroy book" do
  #   assert_difference("Book.count", -1) do
  #     delete book_path(@book)
  #   end

  #   assert_redirected_to books_path
  # end
end
