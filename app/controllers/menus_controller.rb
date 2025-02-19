class MenusController < ApplicationController
  def show
    @menu = Menu.find(params[:id])
    @dishes = @menu.dishes
    Rails.logger.debug "✅ Loaded Menu ##{@menu.id} with #{@dishes.count} dishes"
    respond_to do |format|
      format.html
      format.json { render json: { menu: @menu, dishes: @dishes } }
    end
  end
end
