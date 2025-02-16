class ApplicationController < ActionController::Base
  rescue_from Exception, with: :handle_error_method
  rescue_from NameError, with: :handle_error_method

  def default_url_options
    { host: ENV["DOMAIN"] || "localhost:3000" }
  end

  def handle_error_method
    flash[:notice] = "Burger Boi lost this round! 😢"
    redirect_to root_path
  end
end
