class ProductCsvImport < ProductImport
  def import    
    ProductCsvImportJob.perform_now(@file)
  end
end
