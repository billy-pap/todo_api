require "swagger_helper"

RSpec.describe "Items API", type: :request do
  let!(:user) { User.create!(email: "a@b.com", password: "password123", password_confirmation: "password123") }
  let!(:todo) { user.todos.create!(title: "T1", description: "d") }
  let(:Authorization) { "Token #{user.auth_token}" }

  path "/todos/{todo_id}/items" do
    parameter name: :todo_id, in: :path, type: :integer

    post "Create a new todo item" do
      tags "Items"
      consumes "application/json"
      produces "application/json"
      security [{ TokenAuth: [] }]

      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          item: {
            type: :object,
            properties: {
              content: { type: :string, example: "Buy milk" },
              done: { type: :boolean, example: false }
            },
            required: ["content"]
          }
        },
        required: ["item"]
      }

      response "201", "created" do
        let(:todo_id) { todo.id }
        let(:payload) { { item: { content: "Buy milk", done: false } } }
        run_test!
      end
    end
  end

  path "/todos/{todo_id}/items/{id}" do
    parameter name: :todo_id, in: :path, type: :integer
    parameter name: :id, in: :path, type: :integer

    get "Get a todo item" do
      tags "Items"
      produces "application/json"
      security [{ TokenAuth: [] }]

      response "200", "ok" do
        let!(:item) { todo.items.create!(content: "Buy milk", done: false) }
        let(:todo_id) { todo.id }
        let(:id) { item.id }
        run_test!
      end
    end

    put "Update a todo item" do
      tags "Items"
      consumes "application/json"
      produces "application/json"
      security [{ TokenAuth: [] }]

      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          item: {
            type: :object,
            properties: {
              content: { type: :string, example: "Buy milk" },
              done: { type: :boolean, example: true }
            }
          }
        },
        required: ["item"]
      }

      response "200", "ok" do
        let!(:item) { todo.items.create!(content: "Buy milk", done: false) }
        let(:todo_id) { todo.id }
        let(:id) { item.id }
        let(:payload) { { item: { done: true } } }
        run_test!
      end
    end

    delete "Delete a todo item" do
      tags "Items"
      security [{ TokenAuth: [] }]

      response "204", "no content" do
        let!(:item) { todo.items.create!(content: "Buy milk", done: false) }
        let(:todo_id) { todo.id }
        let(:id) { item.id }
        run_test!
      end
    end
  end
end
