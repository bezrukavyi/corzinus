module Corzinus
  describe InventoriesController, type: :controller do
    routes { Corzinus::Engine.routes }

    subject { create :corzinus_inventory, :with_sales }

    describe 'GET #show' do
      it 'inventory assigns' do
        get :show, params: { id: subject.id }
        expect(assigns[:inventory]).to eq(subject)
      end
    end
  end
end
