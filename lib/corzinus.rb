require 'corzinus/engine'
require 'rectify'
require 'drape'
require 'credit_card_validations'
require 'aasm'
require 'haml'
require 'rails-i18n'
require 'wicked'

module Corzinus
  mattr_accessor :person_class

  def self.person_class
    @@person_class.try(:constantize) || 'TypicalUser'
  end
end
