class AuthController < ApplicationController
  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      user.rotate_auth_token!
      render json: { token: user.auth_token }, status: :ok
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end

  def logout
    authenticate_user!
    return unless current_user

    current_user.invalidate_auth_token!
    render json: { message: "Logged out" }, status: :ok
  end
end
