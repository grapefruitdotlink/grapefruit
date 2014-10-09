class API::V1::ApplicationController < ApplicationController

  skip_before_filter :check_full_profile

private

  def authenticate_user_from_token!
    user_email = request.headers["user-email"].presence
    if user_email.nil?
      user_email = params[:authentication][:email].presence if params[:authentication]
    end

    if user_email.nil?
      render json: { success: false, message: "Email is missing." }, status: 401
      return
    end

    @user = user_email && User.find_by_email(user_email)

    if @user && Devise.secure_compare(@user.authentication_token, request.headers["authentication-token"] || params[:authentication][:token])
      sign_in @user, store: false
    else
      render json: { success: false, message: "Email or authentication_token is invalid." }, status: 401
    end
  end

end