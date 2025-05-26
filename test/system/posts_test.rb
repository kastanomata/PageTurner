require "application_system_test_case"

class PostsTest < ApplicationSystemTestCase
  setup do
    @post = posts(:one)
    @post2 = posts(:two)
    @user = users(:one)
  end

  test "not visiting the index" do
    login_as(@user)
    visit posts_path
    assert_text "We’re sorry, but you're not allowed to see this content"
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

  test "should update Post" do
    login_as(@user)
    visit post_path(@post)

    edit_link = find("a", text: "Edit Post")
    execute_script("arguments[0].click()", edit_link)
    execute_script("document.getElementById('post_title').value = 'Titolo 1'")
    execute_script("document.getElementById('post_text').value = 'Daje'")
    update_button = find("input[value='Update Post']")
    execute_script("arguments[0].click()", update_button)

    assert_text "Post was successfully updated"
    assert_current_path post_path(@post)
  end

  test "Like Post" do
    login_as(@user)
    visit post_path(@post2)
    assert_selector ".post-actions p", text: "1 Like"

    like_button = find("form.button_to button", text: "Like")
    execute_script("arguments[0].click()", like_button)

    assert_selector ".post-actions p", text: "2 Likes"
  end

  test "Unlike Post" do
    login_as(@user)
    visit post_path(@post)
    assert_selector ".post-actions p", text: "1 Like"

    unlike_button = find("form.button_to button", text: "Unlike")
    execute_script("arguments[0].click()", unlike_button)

    assert_selector ".post-actions p", text: "0 Likes"
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
