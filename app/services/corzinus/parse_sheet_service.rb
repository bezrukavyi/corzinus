module Corzinus
  class ParseSheetService
    attr_reader :file, :spread_sheet, :data

    SUPPORT_FORMAT = %w(csv xls xlsx).freeze

    def self.call(*args)
      new(*args).call
    end

    def initialize(file)
      @file = file
      @data = []
    end

    def call
      return unless valid?
      parsed_data
    end

    def valid?
      return false unless file
      SUPPORT_FORMAT.include?(file_extname)
    end

    def file_extname
      @file_extname ||= File.extname(file.original_filename).delete('.')
    end

    private

    def parsed_data
      @lists = open_spreed_sheet.sheets
      @spread_sheet = open_spreed_sheet
      @spread_sheet.each_with_pagename do |name, sheet|
        data.push(read_spreed_sheet(sheet))
      end
      data
    end

    def read_spreed_sheet(spreadsheet)
      header = spreadsheet.row(1)
      @demands = (2..spreadsheet.last_row).each_with_object({}) do |row_number, demands|
        header.each_with_index do |header_id, index|
          demands[header_id] ||= []
          demands[header_id].push(spreadsheet.row(row_number)[index])
        end
      end
    end

    def open_spreed_sheet
      case file_extname
      when 'csv' then Roo::Csv.new(file.path, file_warning: :ignore)
      when 'xls' then Roo::Excel.new(file.path, file_warning: :ignore)
      when 'xlsx' then Roo::Excelx.new(file.path, file_warning: :ignore)
      else raise "Unknown file type: #{file.original_filename}"
      end
    end
  end
end
