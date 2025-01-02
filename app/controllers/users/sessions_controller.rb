class Users::SessionsController < Devise::SessionsController
  def create
    super do |resource|
      session[:show_welcome_message] = true if resource.sign_in_count == 1
    end
  end
end
