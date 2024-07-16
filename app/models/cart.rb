class Cart
  include Mongoid::Document

  field :state, type: String

  has_many :cart_items, dependent: :destroy

  def products
    cart_items.map { |item| item.product }
  end
end
