require 'rails_helper'

module Corzinus
  RSpec.describe Coupon, type: :model do
    subject { build :corzinus_coupon }

    context 'associations' do
      it { should belong_to :order }
    end
  end
end
