# frozen_string_literal: true

module Serializer
  class Swapper
    ATTRIBUTES = %i[
      id
      name
      surname
      email
      phone_number
      date_of_birth
      address
      city
      country
      rating
      user_id
    ]

    def initialize(object)
      ATTRIBUTES.each do |attribute|
        instance_variable_set("@#{attribute}", object.send(attribute))
        self.class.send(:attr_reader, attribute)
      end
    end
  end
end
