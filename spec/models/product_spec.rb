# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe Product, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:swapper) { FactoryBot.create(:swapper, user_id: user.id) }
  
  let(:different_user) do
    FactoryBot.create(
      :user,
      username: 'mariorossi',
      email: 'mariorossi@email.com'
    )
  end

  let(:different_swapper) do
    FactoryBot.create(
      :swapper, 
      user_id: different_user.id)
  end

  subject(:product) do 
    described_class.new(
      category: 'Product::Item',
      title: 'BMC Alpenchallenge AC2',
      description: 'Great hybrid bike ideal for commuting',
      swapper_id: swapper.id
    )
  end

  let(:item) do
    Product.create!(
      category: 'Product::Item',
      title: 'Bike',
      description: 'Amazing hybrid bike',
      swapper_id: swapper.id
    )
  end

  let(:different_swapper_item) do
    Product.create!(
      category: 'Product::Item',
      title: 'Bike',
      description: 'Amazing hybrid bike',
      swapper_id: different_swapper.id
    )
  end

  let(:service) do
    Product.create!(
      category: 'Product::Service',
      title: 'Plumber',
      description: 'Free plumbing service',
      swapper_id: swapper.id
    )
  end

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a category' do
      subject.category = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a title' do
      subject.title = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a description' do
      subject.description = nil
      expect(subject).to_not be_valid
    end
  end

  describe 'scope :by_swapper' do
    it 'only shows products for the requested swapper' do
      expect(Product.by_swapper(swapper.id)).to include(item)
      expect(Product.by_swapper(swapper.id)).not_to include(different_swapper_item)
    end
  end

  describe 'scope :by_category' do
    it 'only shows products for the requested category' do
      expect(Product.by_category('Product::Item')).to include(item)
      expect(Product.by_category('Product::Item')).not_to include(service)
    end
  end
end
