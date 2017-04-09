module Corzinus
  module Support
    module PersonsController
      def stub_current_person(controller, user, type = nil)
        if type == :instance
          allow_any_instance_of(controller).to receive(:current_person).and_return(user)
        else
          allow(controller).to receive(:current_person).and_return(user)
        end
      end
    end
  end
end
