module Corzinus
  class InventoryAnalysisForm < Rectify::Form
    attr_accessor :entity

    attribute :data, String
    attribute :reserves, String

    attribute :demand_data, Hash
    attribute :inventory_data, Hash
    attribute :price_data, Hash
    attribute :original_price_data, Hash

    attribute :delivery_cost, Float
    attribute :warehous_cost, Float

    attribute :delivery_days, Integer

    validates :data, :delivery_cost, :warehous_cost, :reserves, :delivery_days,
              presence: true

    validate :data_valid?

    def attributes
      super.except(:data)
    end

    def save
      if valid?
        persist!
        true
      else
        false
      end
    end

    private

    def persist!
      @entity = InventoryAnalysis.create(attributes)
    end

    def before_validation
      return unless data_valid?
      self.reserves = reserves.to_s.split(' ').uniq.map(&:to_i)
      self.demand_data = parsed_data[0]
      self.inventory_data = parsed_data[1]
      self.price_data = parsed_data[2]
      self.original_price_data = parsed_data[3]
    end

    def data_valid?
      return true if ParseSheetService.new(data).valid?
      errors.add(:data, "INVALID")
      false
    end

    def parsed_data
      @parsed ||= ParseSheetService.call(data)
    end
  end
end
