class ProductCsvImportJob < ApplicationJob
  queue_as :default

  def perform(file_path)
    require 'csv'

    CSV.foreach(file_path, headers: true) do |row|      
      product = Product.find_or_initialize_by(name: row['NAME'])
      product.assign_attributes(        
        category: row['CATEGORY'],
        default_price: row['DEFAULT_PRICE'],
        qty: row['QTY'],
      )

      product.save!
    end
  end
end
