require "application_system_test_case"

class BooksTest < ApplicationSystemTestCase
  setup do
    @book = books(:one)
    @admin = users(:three)
  end

  test "visiting the index" do
    visit books_path
    assert_selector "h1", text: "Books"
  end

  test "should create book" do
    login_as(@admin)
    visit books_path
    click_on "New book"

    fill_in "Title", with: "The Hobbit"
    fill_in "Isbn", with: "9780547928227"
    click_on "Create Book"

    assert_text "Book was successfully created"
    click_on "Back"
  end

  # test "should update Book" do
  #   visit book_path(@book)
  #   click_on "Edit this book", match: :first

  #   fill_in "Isbn", with: @book.isbn
  #   click_on "Update Book"

  #   assert_text "Book was successfully updated"
  #   click_on "Back"
  # end

  test "should destroy Book" do
    login_as(@admin)
    visit book_path(@book)
    click_on "Destroy this book", match: :first

    assert_text "Book was successfully destroyed"
  end
end
