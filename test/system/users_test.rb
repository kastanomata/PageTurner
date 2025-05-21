require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    @admin = users(:three)
  end

  test "visiting the index" do
    login_as(@admin)
    visit users_path
    assert_selector "h1", text: "Users"
  end

  test "should create user" do
    visit root_path
    find(".btn.btn--primary", text: "Register", match: :first).click

    fill_in "Email address", with: "example@example.com"
    fill_in "Password", with: "password"
    click_on "Create User"
    fill_in "Nickname", with: "example"
    fill_in "Description", with: "Description"
    fill_in "Birthday", with: "22/10/2011"
    click_on "Save Changes"

    assert_text "User was successfully updated."
  end

  test "should update User" do
    login_as(@user)
    visit user_path(@user)

    find(".navbar-dropdown-toggle").hover
    within(".navbar-dropdown-menu") do
      edit_link = find("a.navbar-dropdown-item", text: "Edit user")
      execute_script("arguments[0].click()", edit_link)
    end
    assert_current_path edit_user_path(@user)
    execute_script("document.querySelector('.navbar-dropdown-menu').style.display = 'none'")
    assert_no_selector(".navbar-dropdown-menu", visible: true)

    execute_script("document.getElementById('user_nickname').value = 'Spa'")
    execute_script("document.getElementById('user_description').value = 'new description'")
    execute_script("document.getElementById('user_birthday').value = '12-12-2000'")
    save_button = find("input[value='Save Changes']")
    execute_script("arguments[0].click()", save_button)

    assert_current_path user_path(@user)
  end

  test "should destroy User" do
    login_as(@user)
    visit user_path(@user)

    find(".navbar-dropdown-toggle").hover
    within(".navbar-dropdown-menu") do
      logout_button = find("form.button_to button.navbar-dropdown-item", text: "Logout", visible: true)
      execute_script("arguments[0].click()", logout_button)
    end

    assert_current_path root_path
  end
end
