require "swagger_helper"

RSpec.describe "Auth API", type: :request do
  path "/signup" do
    post "Signup" do
      tags "Auth"
      consumes "application/json"
      produces "application/json"

      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string, example: "user@example.com" },
              password: { type: :string, example: "password123" },
              password_confirmation: { type: :string, example: "password123" }
            },
            required: %w[email password password_confirmation]
          }
        },
        required: ["user"]
      }

      response "201", "created" do
        let(:payload) do
          {
            user: {
              email: "rswag_signup_#{SecureRandom.hex(4)}@test.com",
              password: "password123",
              password_confirmation: "password123"
            }
          }
        end

        run_test!
      end

      response "422", "validation error" do
        let(:payload) do
          {
            user: {
              email: "bad_signup_#{SecureRandom.hex(4)}@test.com",
              password: "password123",
              password_confirmation: "nope"
            }
          }
        end

        run_test!
      end
    end
  end

  path "/auth/login" do
    post "Login" do
      tags "Auth"
      consumes "application/json"
      produces "application/json"

      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: "user@example.com" },
          password: { type: :string, example: "password123" }
        },
        required: %w[email password]
      }

      response "200", "ok" do
        let!(:user) do
          User.create!(
            email: "login_#{SecureRandom.hex(4)}@test.com",
            password: "password123",
            password_confirmation: "password123"
          )
        end

        let(:payload) do
          { email: user.email, password: "password123" }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["token"]).to be_present
        end
      end

      response "401", "invalid credentials" do
        let!(:user) do
          User.create!(
            email: "login2_#{SecureRandom.hex(4)}@test.com",
            password: "password123",
            password_confirmation: "password123"
          )
        end

        let(:payload) do
          { email: user.email, password: "WRONGPASS" }
        end

        run_test!
      end
    end
  end

  path "/auth/logout" do
  get "Logout" do
    tags "Auth"
    produces "application/json"

    parameter name: "Authorization", in: :header, type: :string, required: false,
              description: 'Token auth header, e.g. "Token abc123"'

    response "200", "ok" do
      let!(:user) do
        User.create!(
          email: "logout_#{SecureRandom.hex(4)}@test.com",
          password: "password123",
          password_confirmation: "password123"
        )
      end

      before { user.rotate_auth_token! }

      let(:"Authorization") { "Token #{user.auth_token}" }

      run_test!
    end

    response "401", "unauthorized" do
      let(:"Authorization") { nil }
      run_test!
    end
  end
end

end

