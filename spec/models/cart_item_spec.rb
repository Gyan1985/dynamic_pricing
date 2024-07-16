require 'rails_helper'

RSpec.describe CartItem, type: :model do
  let(:product) { create(:product, category: "Electronics", default_price: 999.99, qty: 50 ) }
  let(:cart) { Cart.create(state: "active") }
  let(:cart_item) { CartItem.new(cart: cart, product: product, quantity: 2) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(cart_item).to be_valid
    end

    it 'is not valid if product_id is nil' do
      cart_item.product_id = nil
      expect(cart_item).to_not be_valid
    end
  end
end
