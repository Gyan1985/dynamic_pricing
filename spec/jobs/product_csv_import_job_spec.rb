require 'rails_helper'
require 'csv'

RSpec.describe ProductCsvImportJob, type: :job do
  describe '#perform' do
    let(:file_path) { 'product_import.csv' }

    before do
      CSV.open(file_path, 'wb') do |csv|
        csv << ['NAME', 'CATEGORY', 'DEFAULT_PRICE', 'QTY']
        csv << ['Laptop', 'Electronics', '999.99', '50']
        csv << ['Tablet', 'Electronics', '499.99', '20']
        csv << ['Tablet', 'Electronics', '499.99', '10']
      end
    end

    after do
      File.delete(file_path) if File.exist?(file_path)
    end

    it 'imports products from the CSV file' do      
      expect {
        ProductCsvImportJob.perform_now(file_path)
      }.to change { Product.count }.by(2)      
    end
    
    it 'creates or updates products correctly' do
      ProductCsvImportJob.perform_now(file_path)
      expect(Product.find_by(name: 'Laptop').qty).to eq(50)
      expect(Product.find_by(name: 'Tablet').qty).to eq(10)
    end
  end
end
