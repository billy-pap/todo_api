class ApplicationController < ActionController::API
  private

  def authenticate_user!
    header = request.headers["Authorization"].to_s

    
    token = header.split.last
    @current_user = User.find_by(auth_token: token)

    unless @current_user
      render json: { error: "Unauthorized!" }, status: :unauthorized
      return
    end
  end

  def current_user
    @current_user
  end
end

