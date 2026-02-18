require "rails_helper"

RSpec.describe "Items", type: :request do
  let!(:user) { User.create!(email: "a@b.com", password: "password123", password_confirmation: "password123") }
  let!(:token) { user.auth_token }
  let!(:todo) { user.todos.create!(title: "T1", description: "d") }

  it "creates an item" do
    post "/todos/#{todo.id}/items",
         params: { item: { content: "Buy milk", done: false } },
         headers: auth_header(token)

    expect(response).to have_http_status(:created)
    expect(JSON.parse(response.body)["content"]).to eq("Buy milk")
  end

  it "shows an item" do
    item = todo.items.create!(content: "Buy milk", done: false)

    get "/todos/#{todo.id}/items/#{item.id}", headers: auth_header(token)

    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)["id"]).to eq(item.id)
  end

  it "updates an item" do
    item = todo.items.create!(content: "Buy milk", done: false)

    put "/todos/#{todo.id}/items/#{item.id}",
        params: { item: { done: true } },
        headers: auth_header(token)

    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)["done"]).to eq(true)
  end

  it "deletes an item" do
    item = todo.items.create!(content: "Buy milk", done: false)

    delete "/todos/#{todo.id}/items/#{item.id}", headers: auth_header(token)

    expect(response).to have_http_status(:no_content)
    expect(Item.where(id: item.id)).to be_empty
  end
end
