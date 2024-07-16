class CartItem
  include Mongoid::Document
  include Mongoid::Timestamps

  field :quantity, type: Integer

  belongs_to :cart
  belongs_to :product

  before_create :check_product_availability

  private

  def check_product_availability
    if product.qty < quantity
      errors.add(:quantity, "not enough stock available for #{product.name}")
      throw(:abort)
    end
  end
end
