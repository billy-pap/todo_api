Rails.application.routes.draw do
  post "/signup", to: "signup#create"

  post "/auth/login", to: "auth#login"
  get  "/auth/logout", to: "auth#logout"

  get "/test", to: proc { [200, { "Content-Type" => "application/json" }, [{ message: "API working!" }.to_json]] }

  resources :todos do
    resources :items, only: %i[show create update destroy]
  end

  if Rails.env.development?
    mount Rswag::Ui::Engine => "/api-docs"
    mount Rswag::Api::Engine => "/api-docs"
  end
end
