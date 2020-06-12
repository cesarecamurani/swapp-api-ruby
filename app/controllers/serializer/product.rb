# frozen_string_literal: true

module Serializer
  class Product
    ATTRIBUTES = %i[
      id
      category
      title
      description
      up_for_auction
      department
      swapper_id
    ]

    def initialize(object)
      ATTRIBUTES.each do |attribute|
        instance_variable_set("@#{attribute}", object.send(attribute))
        self.class.send(:attr_reader, attribute)
      end
    end
  end
end
