module Corzinus
  describe ParseSheetService do
    let(:file) { fixture_file_upload('/files/test.xlsx') }
    subject { ParseSheetService.call(file) }

    describe '.call' do
      it 'test' do
        expect(subject[0]).not_to be_blank
        expect(subject[1]).not_to be_blank
        expect(subject[2]).not_to be_blank
        expect(subject[3]).not_to be_blank
      end
    end
  end
end
