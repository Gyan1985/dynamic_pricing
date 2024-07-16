require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  describe 'POST #import' do
    context 'when a file is uploaded' do
      let(:file) { fixture_file_upload('inventory.csv', 'text/csv') }

      it 'imports products and returns a success message' do
        post :import, params: { file: file }

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to eq('message' => 'Products will be imported soon.')
      end
    end

    context 'when no file is uploaded' do
      it 'returns an error message' do
        post :import, params: {}

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq('error' => 'Please upload a file.')
      end
    end
  end
  
  describe 'GET #index' do
    context 'when paginating' do
      let!(:products) { create_list(:product, 10) } 
      it 'returns the correct number of products on the first page' do
        get :index, params: { page: 1, per_page: 5 }
        
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body).size).to eq(5)
      end
    end
  end
end
