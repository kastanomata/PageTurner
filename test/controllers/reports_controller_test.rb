require "test_helper"

class ReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @report = reports(:one)
    @other_report = reports(:two)
    @admin = users(:two)
  end

  test "should get index" do
    post session_path, params: { email_address: @admin.email_address, password: "password" }
    assert_equal @admin.id, session[:user_id]
    get reports_path
    assert_response :success
  end

  test "should get new" do
    get new_report_path
    assert_response :success
  end

  test "should create report" do
    assert_difference("Report.count") do
      post reports_path, params: { report: { reported_id: @report.reported_id, reported_type: @report.reported_type, reporter_id: @report.reporter_id } }
    end

    assert_redirected_to report_path(Report.last)
  end

  test "should show report" do
    post session_path, params: { email_address: @admin.email_address, password: "password" }
    assert_equal @admin.id, session[:user_id]
    get report_path(@report)
    assert_response :success
  end

  test "should get edit" do
    post session_path, params: { email_address: @admin.email_address, password: "password" }
    assert_equal @admin.id, session[:user_id]
    get edit_report_path(@report)
    assert_response :success
  end

  test "should update report" do
    post session_path, params: { email_address: @admin.email_address, password: "password" }
    assert_equal @admin.id, session[:user_id]
    patch report_path(@report), params: { report: { reported_id: @report.reported_id, reported_type: @report.reported_type, reporter_id: @report.reporter_id } }
    assert_redirected_to report_path(@report)
  end

  test "should destroy report" do
    post session_path, params: { email_address: @admin.email_address, password: "password" }
    assert_equal @admin.id, session[:user_id]
    puts @report.inspect
    assert_difference("Report.count", -1) do
      delete report_path(@report)
    end

    assert_redirected_to reports_path
  end
end
