# frozen_string_literal: true

class Product < ApplicationRecord
  belongs_to :swapper

  validates :category, :title, :description, presence: true
end
