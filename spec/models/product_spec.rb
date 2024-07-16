require 'rails_helper'

RSpec.describe Product, type: :model do
  let!(:product) { Product.new(name: 'Laptop', category: "Electronics", default_price: 999.99, qty: 50 ) }
  
  describe 'validations' do
    it 'is valid with valid attributes' do      
      expect(product).to be_valid
    end
    
    it 'is not valid without a name' do
      product.name = nil
      expect(product).to_not be_valid
    end
    
    it 'is not valid without a category' do
      product.category = nil
      expect(product).to_not be_valid
    end
    
    it 'is not valid with a duplicate name' do    
      product.save!      
      duplicate_product = Product.new(name: "Laptop", category: "Gadgets", default_price: 899.99, qty: 30)      
      expect(duplicate_product).to_not be_valid
    end
  end
end
