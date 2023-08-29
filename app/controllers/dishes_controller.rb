class DishesController < ApplicationController
  def hehe
    @menu = Menu.new(menu_params)
    @menu.user = current_user
    @menu.save
    redirect_to menu_dishes_path(@menu)
  end

  private

  def menu_params
    params.require(:menu).permit(:restaurant_name, :photo)
  end
end
