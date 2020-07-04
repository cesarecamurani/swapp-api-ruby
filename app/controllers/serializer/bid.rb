# frozen_string_literal: true

module Serializer
  class Bid
    ATTRIBUTES = %i[id product_id state auction_id]

    def initialize(object)
      ATTRIBUTES.each do |attribute|
        instance_variable_set("@#{attribute}", object.send(attribute))
        self.class.send(:attr_reader, attribute)
      end
    end
  end
end
