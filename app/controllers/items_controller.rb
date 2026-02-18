class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_todo
  before_action :set_item, only: %i[show update destroy]

  def show
    render json: @item, status: :ok
  end

  def create
    item = @todo.items.new(item_params)
    if item.save
      render json: item, status: :created
    else
      render json: { errors: item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @item.update(item_params)
      render json: @item, status: :ok
    else
      render json: { errors: item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy
    head :no_content
  end

  private

  def set_todo
    @todo = current_user.todos.find(params[:todo_id])
  end

  def set_item
    @item = @todo.items.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:content, :done)
  end
end

