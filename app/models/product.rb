class Product
  include Mongoid::Document

  field :name, type: String
  field :category, type: String
  field :default_price, type: Float
  field :qty, type: Integer, default: 1 

  validates :name, presence: true, uniqueness: true
  validates :category, presence: true

  has_many :cart_items

  DAYS_TO_CONSIDER = 7.days.ago

  def items_count        
    cart_items.where(:created_at.gte => DAYS_TO_CONSIDER).count
  end
end
