class ReportsController < ApplicationController
  before_action :set_report, only: %i[ show edit update destroy ]
  before_action -> { require_authentication("admin") }, only: %i[ index destroy ]

  # GET /reports or /reports.json
  def index
    @reports = Report.all
  end

  # GET /reports/1 or /reports/1.json
  def show
  end

  # GET /reports/new
  def new
    @report = Report.new
  end

  # GET /reports/1/edit
  def edit
  end

  # POST /reports or /reports.json
  def create
    @report = Report.new(report_params)

    respond_to do |format|
      if @report.save
        format.html
        format.json { render :show, status: :created, location: @report }
      else
        format.html
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reports/1 or /reports/1.json
  def update
    respond_to do |format|
      if @report.update(report_params)
        format.html
        format.json { render :show, status: :ok, location: @report }
      else
        format.html
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1 or /reports/1.json
  def destroy
    @report.destroy!

    respond_to do |format|
      format.html { redirect_to reports_path, status: :see_other, notice: "Report was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def report_params
      params.expect(report: [ :reporter_id, :reported_id, :reported_type ])
    end
end
