require 'corzinus/engine'
require 'rectify'
require 'drape'
require 'credit_card_validations'
require 'aasm'

module Corzinus
  mattr_accessor :person_class

  def self.person_class
    @@person_class.try(:constantize) || 'TypicalUser'
  end
end
