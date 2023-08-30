class DishesController < ApplicationController
  before_action :set_dish, only: [:show]
   def index
    @dishes = Dish.all
   end

  def hehe
    @menu = Menu.new(menu_params)
    @menu.user = current_user
    @menu.save
    redirect_to menu_dishes_path(@menu)
  end

  def show

  end

  private

  def set_dish
    @dish = Dish.find(params[:id])
  end

  def menu_params
    params.require(:menu).permit(:restaurant_name, :photo)
  end
end
