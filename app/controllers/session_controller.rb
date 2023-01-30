class SessionController < ApplicationController
    def signup
      # Create a user or admin based on the role parameter
      if params[:role] == 'user'
        user = User.create(user_params)
        if user.valid?
          # Generate a JWT and send it as the response
          token = JWT.encode({ user_id: user.id, role: 'user' }, Rails.application.secrets.secret_key_base, 'HS256')
          render json: { token: token, message: 'Successfully signed up as user' }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :bad_request
        end
      elsif params[:role] == 'admin'
        admin = Admin.create(admin_params)
        if admin.valid?
          # Generate a JWT and send it as the response
          token = JWT.encode({ admin_id: admin.id, role: 'admin' }, Rails.application.secrets.secret_key_base, 'HS256')
          render json: { token: token, message: 'Successfully signed up as admin' }, status: :created
        else
          render json: { errors: admin.errors.full_messages }, status: :bad_request
        end
      else
        render json: { message: 'Invalid role, must be either user or admin' }, status: :bad_request
      end
    end
  
    def signin
      # Authenticate the user or admin based on the role parameter
      if params[:role] == 'user'
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
          # Generate a JWT and send it as the response
          token = JWT.encode({ user_id: user.id, role: 'user' }, Rails.application.secrets.secret_key_base, 'HS256')
          render json: { token: token, message: 'Successfully signed in as user' }, status: :ok
        else
          render json: { message: 'Incorrect email or password' }, status: :unauthorized
        end
      elsif params[:role] == 'admin'
        admin = Admin.find_by(email: params[:email])
        if admin&.authenticate(params[:password])
          # Generate a JWT and send it as the response
          token = JWT.encode({ admin_id: admin.id, role: 'admin' }, Rails.application.secrets.secret_key_base, 'HS256')
          render json: { token: token, message: 'Successfully signed in as admin' }, status: :ok
        else
          render json: { message: 'Incorrect email or password' }, status: :unauthorized
        end
      else
        render json: { message: 'Invalid role, must be either user or admin' }, status: :bad_request
      end
    end
  
    def signout
      # No action needed for sign out, just return success status
      render json: { message: 'Successfully signed out' }, status: :ok
    end
    private

    def user_params
        params.permit(:email, :password)
    end

    def admin_params
        params.permit(:email, :password)
    end
end