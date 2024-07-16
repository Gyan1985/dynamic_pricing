class ProductsController < ApplicationController
  def index
    @products = Kaminari.paginate_array(Product.all).page(params[:page]).per(params[:per_page])
    render json: @products
  end

  def import    
    if params[:file].present?
      importer = file_importer(params[:file])
      render json: { message: 'Products will be imported soon.' }, status: :created
    else
      render json: { error: 'Please upload a file.' }, status: :unprocessable_entity
    end
  end

  private 

  def file_importer(file)    
    case File.extname(file.original_filename)
    when '.csv'
      ProductCsvImport.new(file).import
    else
      raise "Unsupported file type"
    end
  end
end
