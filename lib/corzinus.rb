require 'corzinus/engine'

module Corzinus
  mattr_accessor :person_class

  def self.person_class
    @@person_class.try(:constantize)
  end
end
