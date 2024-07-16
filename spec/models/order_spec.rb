require 'rails_helper'

RSpec.describe Order, type: :model do
  let!(:product) { create(:product, category: "Electronics", default_price: 999.99, qty: 50) }
  let!(:cart) { Cart.create(state: "active") }
  let!(:cart_item) { cart.cart_items.create(product: product, quantity: 2) }
  let!(:order) { Order.create(cart: cart) }

  describe 'callbacks' do
    it 'decrements product quantity when order is placed' do      
      order.update(state: :placed)      
      expect(product.qty).to eq(48)
    end
  end
end
