require "application_system_test_case"

class ClubsTest < ApplicationSystemTestCase
  setup do
    @club = clubs(:one)
    @user = users(:one)
    @user4 = users(:four)
  end

  test "visiting the index" do
    visit clubs_path
    assert_selector "h1", text: "Clubs"
  end

  test "should create club" do
    login_as(@user4)
    find(".navbar-dropdown-toggle").hover
    within(".navbar-dropdown-menu") do
      club_link = find("a.navbar-dropdown-item", text: "Become a Curator")
      execute_script("arguments[0].click()", club_link)
    end

    execute_script("document.getElementById('club_name').value = 'example'")
    execute_script("document.getElementById('club_description').value = 'new description'")
    club_button = find("input[value='Create Club']")
    execute_script("arguments[0].click()", club_button)

    assert_text "Club was successfully created."
  end

  test "suggested books" do
    login_as(@user)
    visit club_path(@club)

    dropdown = find("#book_suggestion_book_id")
    within dropdown do
      find("option", text: "Select a book", exact: true).click
    end
    find("option", text: "The Fellowship of the Ring", exact: true).click

    click_on "Suggest Book"

    assert_text "The Fellowship of the Ring"
  end

  test "reading goal" do
    login_as(@user)
    visit club_path(@club)

    click_on "Add New Reading Goal"

    dropdown = find("#reading_goal_book_id")
    within dropdown do
      find("option", text: "Please select", exact: true).click
    end
    find("option", text: "The Fellowship of the Ring", exact: true).click

    execute_script <<-JS
      document.querySelector("[name='reading_goal[start_date]']").value = '2025-10-15';
      document.querySelector("[name='reading_goal[start_date]']").dispatchEvent(new Event('change'));
      document.querySelector("[name='reading_goal[end_date]']").value = '2025-10-25';
      document.querySelector("[name='reading_goal[end_date]']").dispatchEvent(new Event('change'));
    JS

    create_goal_button = find("input[value='Create Reading Goal']")
    execute_script("arguments[0].click()", create_goal_button)

    assert_text "Current Reading Goals"
  end

  # test "should update Club" do
  #   login_as(@user)
  #   visit club_path(@club)
  #   click_on "Edit this club", match: :first
  #   fill_in "Title", with: "Scudo"
  #   click_on "Update Club"
# 
  #   assert_text "Club was successfully updated"
  #   assert_current_path club_path(@club)
  # end

  # test "should destroy Club" do
  #   login_as(@user)
  #   visit club_path(@club)
  #   click_on "Destroy this club", match: :first
# 
  #   assert_text "Club was successfully destroyed"
  #   assert_current_path clubs_path
  # end
end
