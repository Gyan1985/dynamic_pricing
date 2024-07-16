class Order
  include Mongoid::Document

  field :state, type: String, default: 'in_progress'

  STATES = %w[placed in_progress confirmed].freeze

  validates :state, inclusion: { in: STATES }

  belongs_to :cart
  has_many :cart_items

  before_update :update_product_quantities

  private

  def update_product_quantities
    return unless self.valid?    
    
    cart.cart_items.each do |cart_item| 
      cart_item.product.update(qty: cart_item.product.qty - cart_item.quantity)
    end
  end
end
