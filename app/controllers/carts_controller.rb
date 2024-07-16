class CartsController < ApplicationController
  def create
    cart = Cart.new(state: "active")

    if cart.save
      render json: { message: 'Cart created successfully.', cart: cart }, status: :created
    else
      render json: { error: cart.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def add_items
    begin
      unless cart = Cart.find(params[:id])
        raise Mongoid::Errors::DocumentNotFound.new 'Cart not found.'
      end
      
      items = params[:items]
      items.each do |item|    
        unless product = Product.find(item[:product_id])
          raise Mongoid::Errors::DocumentNotFound.new "Product with id #{item[:product_id]} not found."
        end
                
        cart_item = cart.cart_items.new(product: product, quantity: item[:qty])

        unless cart_item.save
          return render json: { error: cart_item.errors.full_messages }, status: :unprocessable_entity
        end
      end
    rescue Mongoid::Errors::DocumentNotFound => e
      return render json: { error: e.message }, status: :not_found
    rescue StandardError => e
      render json: { error: 'An unexpected error occurred.', details: e.message }, status: :internal_server_error
    end

    render json: { message: 'Items added to cart successfully.', cart: cart }, status: :created
  end
end
