class OrdersController < ApplicationController
  def create
    begin
      cart = Cart.find(params[:cart_id])
      order = Order.new(cart: cart)

      if order.save
        render json: { message: 'Order created successfully.', order: order }, status: :created
      else
        render json: { error: order.errors.full_messages }, status: :unprocessable_entity
      end
    rescue Mongoid::Errors::DocumentNotFound
      render json: { error: 'Cart not found.' }, status: :not_found
    rescue StandardError => e
      render json: { error: 'An unexpected error occurred.', details: e.message }, status: :internal_server_error
    end
  end

  def update
    begin
      order = Order.find(params[:id])
      if order.update(state: params[:state])
        render json: { message: 'Order is now placed.', order: order }, status: :ok
      else
        render json: { error: order.errors.full_messages }, status: :unprocessable_entity
      end
    rescue Mongoid::Errors::DocumentNotFound
      render json: { error: 'Order not found.' }, status: :not_found
    rescue StandardError => e
      render json: { error: 'An unexpected error occurred.', details: e.message }, status: :internal_server_error
    end
  end
end
