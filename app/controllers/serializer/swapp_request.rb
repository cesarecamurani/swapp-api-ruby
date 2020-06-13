# frozen_string_literal: true

module Serializer
  class SwappRequest
    ATTRIBUTES = %i[
      id
      state
      swapper_id
      offered_product_id
      requested_product_id
      req_product_owner_id
    ]

    def initialize(object)
      ATTRIBUTES.each do |attribute|
        instance_variable_set("@#{attribute}", object.send(attribute))
        self.class.send(:attr_reader, attribute)
      end
    end
  end
end
