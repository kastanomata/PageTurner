require "application_system_test_case"

class ReportsTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    @user2 = users(:two)
    @admin = users(:three)
    @post = posts(:one)
  end

  test "visiting the index" do
    login_as(@admin)
    visit reports_path
    assert_selector "h1", text: "Reports"
  end

  test "should create report post" do
    login_as(@user)
    visit post_path(@user2)
    click_on "Report Post"

    assert_current_path post_path(@user2)
  end

  # test "should update Report" do
  #   visit report_path(@report)
  #   click_on "Edit this report", match: :first

  #   fill_in "Reported", with: @report.reported_id
  #   fill_in "Reported type", with: @report.reported_type
  #   fill_in "Reporter", with: @report.reporter_id
  #   click_on "Update Report"

  #   assert_text "Report was successfully updated"
  #   click_on "Back"
  # end

  test "should destroy Report" do
    login_as(@admin)
    visit report_path(@report)
    click_on "Delete", match: :first

    assert_text "Report was successfully destroyed"
  end
end
