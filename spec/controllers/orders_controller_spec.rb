require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let!(:cart) { Cart.create(state: "active") }

  describe 'POST #create' do
    it 'creates an order with the cart' do
      post :create, params: { cart_id: cart.id }

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)).to include('message' => 'Order created successfully.')
    end

    it 'returns an error if the cart does not exist' do
      post :create, params: { cart_id: 'invalid_id' }
        
      expect(JSON.parse(response.body)['error']).to include("Cart not found.")
    end
  end

  describe 'PATCH #update' do
    let(:order) { Order.create(cart: cart) }

    it 'updates the order state to placed' do
      patch :update, params: { id: order.id, state: 'placed' }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include('message' => 'Order is now placed.')
      expect(order.reload.state).to eq('placed')
    end

    it 'returns an error if the order does not exist' do
      patch :update, params: { id: 'invalid_id' }

      expect(JSON.parse(response.body)['error']).to include("Order not found.")
    end
  end
end
