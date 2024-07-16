require 'net/http'
require 'json'

class PriceAdjusterJob < ApplicationJob
  queue_as :default
  
  PRICE_INCREASE_PERCENTAGE = 1.10
  PRICE_DECREASE_PERCENTAGE = 0.95

  def perform
    competitor_prices = CompetitorPriceService.new.fetch_prices

    competitor_prices.each do |competitor_price|          
      product = Product.find_by(name: competitor_price['name'])      
      if product
        adjust_price(product, competitor_price['price'])
      else
        Rails.logger("Product #{competitor_price['name']} not found.")
      end
    end
  end

  private

  def adjust_price(product, competitor_price)    
    adjust_based_on_competitor_price(product, competitor_price)
    adjust_based_on_demand(product)
    adjust_based_on_inventory(product)

    # To ensure the final price is at least as low as the competitor price
    ensure_final_price_is_competitive(product, competitor_price)

    product.save!
  end

  def adjust_based_on_competitor_price(product, competitor_price)
    if competitor_price < product.default_price
      product.default_price = competitor_price * 0.98 # 2% lower than competitor price
    else
      product.default_price = competitor_price * 1.03 # 3% higher than competitor price
    end
  end

  def adjust_based_on_demand(product)    
    recent_cart_items_count = product.items_count

    if recent_cart_items_count > 100
      product.default_price *= PRICE_INCREASE_PERCENTAGE # Increase by 10%
    elsif recent_cart_items_count < 30
      product.default_price *= PRICE_DECREASE_PERCENTAGE # Decrease by 5%
    end
  end

  def adjust_based_on_inventory(product)    
    if product.qty > 500
      product.default_price *= PRICE_DECREASE_PERCENTAGE # Decrease by 5%
    elsif product.qty < 100
      product.default_price *= PRICE_INCREASE_PERCENTAGE # Increase by 10%
    end
  end

  def ensure_final_price_is_competitive(product, competitor_price)     
    if competitor_price < product.default_price
      product.default_price = competitor_price * 0.98
    end
  end
end