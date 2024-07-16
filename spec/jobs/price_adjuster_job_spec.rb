require 'rails_helper'

RSpec.describe PriceAdjusterJob, type: :job do
  let!(:product_1) { Product.create(name: 'Test Product', category: 'category', default_price: 100.0, qty: 60) }  
  let!(:product_2) { Product.create(name: 'Test Product2', category: 'category', default_price: 100.0, qty: 600) }
  let!(:product_3) { Product.create(name: 'Test Product3', category: 'category', default_price: 100.0, qty: 50) }    
  let!(:cart_1) { Cart.create(state: :in_progress) }
  let!(:cart_items_1) { create_list(:cart_item, 40, product_id: product_1.id, cart_id: cart_1.id) }
  
  describe '#perform' do
    context 'when the product exists' do
      it 'adjusts the product price based on competitor pricing' do
        allow_any_instance_of(CompetitorPriceService).to receive(:fetch_prices).and_return(
          [
            { 'name' => 'Test Product', 'price' => 90.0 },        
          ]
        )
        PriceAdjusterJob.perform_now

        expect(product_1.reload.default_price).to eq(90.0 * 0.98)
      end
    end
    
    context 'when the product exists more than 500' do      
      it 'adjusts the product price based on demand decrease, inventory increase' do        
        product_1.update(qty: 600)
        product_1.cart_items.delete_all
    
        allow_any_instance_of(CompetitorPriceService).to receive(:fetch_prices).and_return(
          [
            { 'name' => 'Test Product', 'price' => 99.0 }
          ]
        )
        
        PriceAdjusterJob.perform_now

        expected_price = 99 * 0.98 * 0.95 * 0.95
        expect(product_1.reload.default_price).to eq(expected_price)
      end
    end

    context 'when the product demand more than 100' do
      let!(:cart_items_2) { create_list(:cart_item, 140, product_id: product_1.id, cart_id: cart_1.id) }

      it 'adjusts the product price based on demand increase' do        
        product_1.update(qty: 600)
    
        allow_any_instance_of(CompetitorPriceService).to receive(:fetch_prices).and_return(
          [
            { 'name' => 'Test Product', 'price' => 99.0 },            
          ]
        )
        
        PriceAdjusterJob.perform_now

        expected_price = 99 * 0.98
        expect(product_1.reload.default_price).to eq(expected_price)
      end
    end

    context 'when the product inventory more than 500' do
      it 'adjusts the product price based on inventory increase' do        
        product_1.update(qty: 600)
    
        allow_any_instance_of(CompetitorPriceService).to receive(:fetch_prices).and_return(
          [
            { 'name' => 'Test Product', 'price' => 99.0 },            
          ]
        )
        
        PriceAdjusterJob.perform_now

        expected_price = 99 * 0.98 * 0.95
        expect(product_1.reload.default_price).to eq(expected_price)
      end
    end   
  end
end