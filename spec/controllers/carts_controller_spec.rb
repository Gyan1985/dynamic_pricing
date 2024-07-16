require 'rails_helper'

RSpec.describe CartsController, type: :controller do
  let!(:product1) { create(:product, category: "Electronics", default_price: 999.99, qty: 50) }
  let!(:product2) { create(:product, category: "Electronics", default_price: 499.99, qty: 20) }

  describe 'POST #create' do
    it 'creates a cart successfully' do
      post :create

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)).to include('message' => 'Cart created successfully.')
    end
  end

  describe 'POST #add_items' do
    let!(:cart) { Cart.create(state: "active") }

    it 'adds multiple items to the cart successfully' do
      post :add_items, params: { id: cart.id, items: [
        { product_id: product1.id, qty: 2 },
        { product_id: product2.id, qty: 3 }
      ] }
      
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)).to include('message' => 'Items added to cart successfully.')
    end

    it 'returns an error if a product does not exist' do
      post :add_items, params: { id: cart.id, items: [
        { product_id: 'invalid_id', qty: 2 },
        { product_id: product2.id, qty: 3 }
      ] }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)).to include('error')
    end    
  end
end
