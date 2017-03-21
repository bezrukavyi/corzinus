module Corzinus
  describe InventorySalesController, type: :controller do
    routes { Corzinus::Engine.routes }

    describe 'GET #index' do
      before do
        @inventory = create :corzinus_inventory, :with_sales
        get :index, inventory_id: @inventory.id
      end
      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end
      it 'assign sales' do
        expect(assigns[:sales]).to eq(@inventory.sales)
      end
    end
  end
end
