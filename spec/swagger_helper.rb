require "rails_helper"

RSpec.configure do |config|
  config.swagger_root = Rails.root.join("swagger").to_s

  config.swagger_docs = {
    "v1/swagger.yaml" => {
      openapi: "3.0.1",
      info: {
        title: "Todo API",
        version: "v1"
      },
      components: {
        securitySchemes: {
          TokenAuth: {
            type: :apiKey,
            name: "Authorization",
            in: :header,
            description: "Use: Token YOUR_TOKEN"
          }
        }
      },
      paths: {}
    }
  }

  config.swagger_format = :yaml
end

