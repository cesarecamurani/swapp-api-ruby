# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe Product, type: :model do
  let(:user) { create(:user) }
  let(:swapper) { create(:swapper, user_id: user.id) }
  
  let(:different_user) do
    create(
      :user,
      username: 'mariorossi',
      email: 'mariorossi@email.com'
    )
  end

  let(:different_swapper) do
    create(
      :swapper, 
      user_id: different_user.id
    )
  end

  subject(:product) do 
    described_class.new(
      category: 'Product::Item',
      title: 'BMC Alpenchallenge AC2',
      description: 'Great hybrid bike ideal for commuting',
      department: 'Sport and Outdoor',
      swapper_id: swapper.id
    )
  end

  let(:item) { create(:item, swapper_id: swapper.id) }
  let(:different_swapper_item) { create(:item, swapper_id: different_swapper.id) }
  let(:service) { create(:service, swapper_id: swapper.id) }

  describe 'Validations' do
    context 'valid' do
      it 'is valid with valid attributes' do
        expect(subject).to be_valid
      end  
    end
    
    context 'invalid' do
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
  
      it 'is not valid without a department' do
        subject.department = nil
        expect(subject).to_not be_valid
      end
    end
  end

  describe 'Scopes' do
    context 'by_swapper' do
      it 'only shows products for the requested swapper' do
        expect(Product.by_swapper(swapper.id)).to include(item)
        expect(Product.by_swapper(swapper.id)).not_to include(different_swapper_item)
      end
    end
  
    context 'by_category' do
      it 'only shows products for the requested category' do
        expect(Product.by_category('Product::Item')).to include(item)
        expect(Product.by_category('Product::Item')).not_to include(service)
      end
    end
  
    context 'by_department' do
      it 'only shows products for the requested department' do
        expect(Product.by_department('Sport and Outdoor')).to include(item)
        expect(Product.by_department('Sport and Outdoor')).not_to include(service)
      end
    end
  end
end
