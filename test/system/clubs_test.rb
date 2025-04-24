require "application_system_test_case"

class ClubsTest < ApplicationSystemTestCase
  setup do
    @club = clubs(:one)
    @user = users(:one)
  end

  test "visiting the index" do
    visit clubs_path
    assert_selector "h1", text: "Clubs"
  end

  # test "should create club" do
  #   visit clubs_path
  #   click_on "New club"

  #   click_on "Create Club"

  #   assert_text "Club was successfully created"
  #   click_on "Back"
  # end

  test "should update Club" do
    login_as(@user)
    visit club_path(@club)
    click_on "Edit this club", match: :first
    fill_in "Title", with: "Scudo"
    click_on "Update Club"

    assert_text "Club was successfully updated"
    assert_current_path club_path(@club)
  end

  test "should destroy Club" do
    login_as(@user)
    visit club_path(@club)
    click_on "Destroy this club", match: :first

    assert_text "Club was successfully destroyed"
    assert_current_path clubs_path
  end
end
