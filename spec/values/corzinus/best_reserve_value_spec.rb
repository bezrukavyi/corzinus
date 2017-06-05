module Corzinus
  describe BestReserveValue do
    let(:file) { fixture_file_upload('/files/test.xlsx') }
    let(:data) { ParseSheetService.call(file) }

    before do
      allow_any_instance_of(InventoryAnalysisForm).to receive(:parsed_data).and_return(data)
    end

    it 'test' do
      params = {
        reserves: '4, 5, 6, 7, 8',
        delivery_cost: 4,
        warehous_cost: 1,
        delivery_days: 4,
        data: file
      }
      form = InventoryAnalysisForm.from_params(params)
      form.valid?
      attributes = form.attributes.deep_transform_keys! { |key| key.to_s }
      best_reserve = BestReserveValue.new(attributes).all_profits
      expect(best_reserve.keys.first).to eq('8')
      expect(best_reserve.keys.last).to eq('4')
    end
  end
end
