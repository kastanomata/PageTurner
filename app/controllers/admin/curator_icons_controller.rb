class Admin::CuratorIconsController < ApplicationController
  before_action :ensure_admin
  before_action :set_curator_icon, only: [ :destroy ]

  def index
    @curator_icons = CuratorIcon.all
  end

  def new
    @curator_icon = CuratorIcon.new
  end

  def create
    @curator_icon = CuratorIcon.new(curator_icon_params)
    if @curator_icon.save
      redirect_to admin_curator_icons_path, notice: "Icon created."
    else
      render :new
    end
  end

  def destroy
    @curator_icon.destroy
    redirect_to admin_curator_icons_path,
                notice: "Icon was successfully deleted."
  end

  private

  def set_curator_icon
    @curator_icon = CuratorIcon.find(params[:id])
  end

  def curator_icon_params
    params.require(:curator_icon).permit(:name, :icon)
  end

  def ensure_admin
    redirect_to root_path unless Current.user&.admin?
  end
end
