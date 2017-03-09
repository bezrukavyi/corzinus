module Corzinus
  module Support
    module PersonsController
      def stub_current_person(controller, user)
        allow(controller).to receive(:current_person).and_return(user)
      end
    end
  end
end
