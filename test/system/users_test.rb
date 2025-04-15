require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  setup do
    @user = users(:three)
  end

  test "visiting the index" do
    visit users_url
    assert_selector "h1", text: "Users"
  end

  test "should create user" do
    visit users_url
    click_on "Register"

    fill_in "Email address", with: @user.email_address
    fill_in "Password", with: @user.password_digest
    click_on "Create User"
    fill_in "Nickname", with: @user.nickname
    fill_in "Description", with: @user.description
    fill_in "Birthday", with: @user.birthday
    click_on "Save Changes"

    assert_text "User was successfully created"
  end

  test "should update User" do
    visit user_url(@user)
    click_on "Edit this user", match: :first

    fill_in "Birthday", with: @user.birthday
    fill_in "Description", with: @user.description
    fill_in "Email", with: @user.email
    fill_in "Nickname", with: @user.nickname
    click_on "Update User"

    assert_text "User was successfully updated"
    click_on "Back"
  end

  test "should destroy User" do
    visit user_url(@user)
    click_on "Destroy this user", match: :first

    assert_text "User was successfully destroyed"
  end
end
