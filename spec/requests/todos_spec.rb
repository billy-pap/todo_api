require "rails_helper"

RSpec.describe "Todos", type: :request do
  let!(:user) { User.create!(email: "a@b.com", password: "password123", password_confirmation: "password123") }
  let!(:token) { user.auth_token }

  it "requires auth" do
    get "/todos"
    expect(response).to have_http_status(:unauthorized)
  end

  it "creates a todo" do
    post "/todos",
         params: { todo: { title: "My todo", description: "desc" } },
         headers: auth_header(token)

    expect(response).to have_http_status(:created)
    json = JSON.parse(response.body)
    expect(json["title"]).to eq("My todo")
  end

  it "lists todos with items" do
    todo = user.todos.create!(title: "T1", description: "d")
    todo.items.create!(content: "Buy milk", done: false)

    get "/todos", headers: auth_header(token)

    expect(response).to have_http_status(:ok)
    json = JSON.parse(response.body)
    expect(json.first["items"]).to be_an(Array)
    expect(json.first["items"].first["content"]).to eq("Buy milk")
  end

  it "shows a single todo" do
    todo = user.todos.create!(title: "T1", description: "d")
    get "/todos/#{todo.id}", headers: auth_header(token)

    expect(response).to have_http_status(:ok)
    json = JSON.parse(response.body)
    expect(json["id"]).to eq(todo.id)
  end

  it "updates a todo" do
    todo = user.todos.create!(title: "T1", description: "d")
    put "/todos/#{todo.id}", params: { todo: { title: "Updated" } }, headers: auth_header(token)

    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)["title"]).to eq("Updated")
  end

  it "deletes a todo and its items" do
    todo = user.todos.create!(title: "T1", description: "d")
    todo.items.create!(content: "x", done: false)

    delete "/todos/#{todo.id}", headers: auth_header(token)

    expect(response).to have_http_status(:no_content)
    expect(Todo.where(id: todo.id)).to be_empty
    expect(Item.where(todo_id: todo.id)).to be_empty
  end
end
