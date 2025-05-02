require "application_system_test_case"

class LikesTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    @admin = users(:three)
    @post = posts(:one)
  end

  # test "visiting the index" do
  #   visit likes_url
  #   assert_selector "h1", text: "Likes"
  # end

  test "should create like" do
    login_as(@admin)
    visit post_path(@post)
    assert_selector "button", text: "Like"

    button = find("button", text: "Like")
    page.execute_script("arguments[0].click();", button)

    assert_current_path post_path(@post)
    assert_selector "button", text: "Unlike"
  end

  # test "should update Like" do
  #   visit like_url(@like)
  #   click_on "Edit this like", match: :first

  #   fill_in "Post", with: @like.post_id
  #   fill_in "User", with: @like.user_id
  #   click_on "Update Like"

  #   assert_text "Like was successfully updated"
  #   click_on "Back"
  # end

  test "should destroy like" do
    login_as(@user)
    visit post_path(@post)
    assert_selector "button", text: "Unlike"

    button = find("button", text: "Unlike")
    page.execute_script("arguments[0].click();", button)

    assert_current_path post_path(@post)
    assert_selector "button", text: "Like"
  end
end
