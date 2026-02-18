module AuthHelper
  def auth_header(token)
    { "Authorization" => "Token #{token}" }
  end
end
