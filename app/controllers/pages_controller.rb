class PagesController < ApplicationController
  # before_action :set_menu
  def new
    @menu = Menu.new
  end

  def set_menu
    # @menu = Menu.find(params[:id])
  end
end
