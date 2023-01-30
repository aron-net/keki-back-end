require 'jwt'
require 'bcrypt'

class UserController < ApplicationController
  before_action :authenticate_user, except: [:signup, :signin, :forgot_password]
  HMAC_SECRET = "your secret key here"
  
  def signup
    @user = User.new(user_params)
    if @user.save
      payload = { user_id: @user.id }
      hmac_secret = HMAC_SECRET
      token = JWT.encode(payload, hmac_secret, 'HS256')
      render json: { message: "User created successfully", auth_token: token }, status: :created
    else
      render json: { errors: @user.errors }, status: :bad_request
    end
  end

  def signin
    user = User.find_by(email: params[:user][:email])
    if user&.authenticate(params[:user][:password])
      payload = { user_id: user.id }
      hmac_secret = HMAC_SECRET
      token = JWT.encode(payload, hmac_secret, 'HS256')
      render json: { message: "Sign in successful", auth_token: token }, status: :ok
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end  

  def forgot_password
    if params[:email].present?
      user = User.find_by(email: params[:email])
      if user
        # send reset password instructions
        render json: { message: "Instructions sent to your email" }, status: :ok
      else
        render json: { error: "Email not found" }, status: :not_found
      end
    else
      render json: { error: "Email is required" }, status: :bad_request
    end
  end
  
  
  def send_reset_password_email(user, token)
    # Use a mailer to send the email to the user
  end
  
  def reset_password
    user = User.find_by(reset_password_token: params[:token])
    if user
      user.update(password: params[:password], reset_password_token: nil)
      render json: { message: "Password reset successfully" }, status: :ok
    else
      render json: { error: "Invalid token" }, status: :not_found
    end
  end

  def signout
    decoded_token = authenticate_user
    return if decoded_token.nil?

    @current_user = User.find(decoded_token[0]["user_id"])
    render json: { message: "Sign out successful" }, status: :ok
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def authenticate_user
    token = request.headers["Authorization"]
    return nil unless token
  
    decoded_token = nil
    begin
      decoded_token = JWT.decode(token.split(" ").last, Rails.application.credentials.jwt_secret, true, { algorithm: 'HS256' })
    rescue JWT::DecodeError
      render json: { error: "Unauthorized" }, status: :unauthorized
      return nil
    end
    decoded_token
  end
end
