require "swagger_helper"

RSpec.describe "Todos API", type: :request do
  let!(:user) { User.create!(email: "a@b.com", password: "password123", password_confirmation: "password123") }
  let(:Authorization) { "Token #{user.auth_token}" }

  path "/todos" do
    get "List all todos (with items)" do
      tags "Todos"
      produces "application/json"
      security [{ TokenAuth: [] }]

      response "200", "ok" do
        run_test!
      end

      response "401", "unauthorized" do
        let(:Authorization) { nil }
        run_test!
      end
    end

    post "Create a new todo" do
      tags "Todos"
      consumes "application/json"
      produces "application/json"
      security [{ TokenAuth: [] }]

      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          todo: {
            type: :object,
            properties: {
              title: { type: :string, example: "My todo" },
              description: { type: :string, example: "desc" }
            },
            required: ["title"]
          }
        },
        required: ["todo"]
      }

      response "201", "created" do
        let(:payload) { { todo: { title: "My todo", description: "desc" } } }
        run_test!
      end

      response "401", "unauthorized" do
        let(:Authorization) { nil }
        let(:payload) { { todo: { title: "My todo" } } }
        run_test!
      end
    end
  end

  path "/todos/{id}" do
    parameter name: :id, in: :path, type: :integer

    get "Get a todo" do
      tags "Todos"
      produces "application/json"
      security [{ TokenAuth: [] }]

      response "200", "ok" do
        let!(:todo) { user.todos.create!(title: "T1", description: "d") }
        let(:id) { todo.id }
        run_test!
      end

      response "404", "not found" do
        let(:id) { 999999 }
        run_test!
      end
    end

    put "Update a todo" do
      tags "Todos"
      consumes "application/json"
      produces "application/json"
      security [{ TokenAuth: [] }]

      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          todo: {
            type: :object,
            properties: {
              title: { type: :string, example: "Updated" },
              description: { type: :string, example: "desc" }
            }
          }
        },
        required: ["todo"]
      }

      response "200", "ok" do
        let!(:todo) { user.todos.create!(title: "T1", description: "d") }
        let(:id) { todo.id }
        let(:payload) { { todo: { title: "Updated" } } }
        run_test!
      end
    end

    delete "Delete a todo and its items" do
      tags "Todos"
      security [{ TokenAuth: [] }]

      response "204", "no content" do
        let!(:todo) { user.todos.create!(title: "T1", description: "d") }
        let!(:item) { todo.items.create!(content: "x", done: false) }
        let(:id) { todo.id }
        run_test!
      end
    end
  end
end
