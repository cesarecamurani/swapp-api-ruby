# frozen_string_literal: true

module Serializer
  class User
    ATTRIBUTES = %i[ id username email ] 

    def initialize(object)
      ATTRIBUTES.each do |attribute|
        instance_variable_set("@#{attribute}", object.send(attribute))
        self.class.send(:attr_reader, attribute)
      end
    end
  end
end
