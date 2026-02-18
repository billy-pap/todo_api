require "rails_helper"

RSpec.describe "Auth", type: :request do
  describe "POST /signup" do
    it "creates a user and returns token" do
      post "/signup", params: { user: { email: "a@b.com", password: "password123", password_confirmation: "password123" } }

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["token"]).to be_present
      expect(json["email"]).to eq("a@b.com")
    end
  end

  describe "POST /auth/login" do
    it "returns a token for valid credentials" do
      User.create!(email: "a@b.com", password: "password123", password_confirmation: "password123")

      post "/auth/login", params: { email: "a@b.com", password: "password123" }

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["token"]).to be_present
    end

    it "rejects invalid credentials" do
      post "/auth/login", params: { email: "no@no.com", password: "bad" }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET /auth/logout" do
    it "invalidates the token" do
      user = User.create!(email: "a@b.com", password: "password123", password_confirmation: "password123")
      token = user.auth_token

      get "/auth/logout", headers: auth_header(token)

      expect(response).to have_http_status(:ok)
      expect(user.reload.auth_token).to be_nil
    end
  end
end
