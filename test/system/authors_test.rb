require "application_system_test_case"

class AuthorsTest < ApplicationSystemTestCase
  setup do
    @author = authors(:one)
    @admin = users(:three)
  end

  test "visiting the index" do
    login_as(@admin)
    visit authors_path
    assert_selector "h1", text: "Authors"
  end

  test "should create author" do
    visit authors_path
    click_on "New author"

    click_on "Create Author"

    assert_text "Author was successfully created"
    click_on "Back"
  end

  test "should update Author" do
    visit author_path(@author)
    click_on "Edit this author", match: :first

    click_on "Update Author"

    assert_text "Author was successfully updated"
    click_on "Back"
  end

  test "should destroy Author" do
    visit author_path(@author)
    click_on "Destroy this author", match: :first

    assert_text "Author was successfully destroyed"
  end
end
