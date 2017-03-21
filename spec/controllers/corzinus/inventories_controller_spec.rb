module Corzinus
  describe InventoriesController, type: :controller do
    routes { Corzinus::Engine.routes }

    subject { create :corzinus_inventory, :with_sales }

    describe 'GET #index' do
      it 'inventorirs assigns' do
        inventory = create :corzinus_inventory, :with_sales
        get :index
        expect(assigns[:inventories]).to eq([inventory, subject])
      end
      it 'order by created' do
        expect(Inventory).to receive(:order).with(:created_at)
          .and_return(Inventory)
        get :index
      end
      it 'render index view' do
        get :index
        expect(response).to render_template(:index)
      end
    end

    describe 'GET #show' do
      before do
        get :show, params: { id: subject.id }
      end
      it 'inventory assigns' do
        expect(assigns[:inventory]).to eq(subject)
      end
      it 'render show view' do
        expect(response).to render_template(:show)
      end
    end
  end
end
