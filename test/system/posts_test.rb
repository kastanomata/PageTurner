require "application_system_test_case"

class PostsTest < ApplicationSystemTestCase
  setup do
    @post = posts(:one)
    @post2 = posts(:two)
    @user = users(:one)
  end

  test "visiting the index" do
    visit posts_path
    assert_selector "h1", text: "Posts"
  end

  test "should create post" do
    login_as(@user)
    visit root_path

    execute_script("document.getElementById('post_isbn').value = '9780618346257'")
    execute_script("document.getElementById('post_title').value = 'Post title'")
    execute_script("document.getElementById('post_text').value = 'Mina'")
    post_button = find("input[value='Post']")
    execute_script("arguments[0].click()", post_button)

    assert_text "Post created!"
  end

  # test "should update Post" do
  #   visit post_path(@post)
  #   click_on "Edit this post", match: :first

  #   fill_in "Text", with: @post.text
  #   fill_in "Title", with: @post.title
  #   click_on "Update Post"

  #   assert_text "Post was successfully updated"
  #   click_on "Back"
  # end

  test "Like Post" do
    login_as(@user)
    visit post_path(@post2)
    assert_selector ".post-actions p", text: "1 Like"

    like_button = find("form.button_to button", text: "Like")
    execute_script("arguments[0].click()", like_button)

    assert_selector ".post-actions p", text: "2 Likes"
  end

  test "should remove Post from Club" do
    login_as(@user)
    visit post_path(@post)
    remove_button = find("form.button_to button", text: "Remove from Club")
    execute_script("arguments[0].click()", remove_button)

    assert_text "Post successfully removed from the club."
  end

  test "should destroy Post" do
    login_as(@user)
    visit post_path(@post)
    destroy_button = find("form.button_to button", text: "Destroy this post")
    execute_script("arguments[0].click()", destroy_button)

    assert_text "Post was successfully destroyed."
  end
end
