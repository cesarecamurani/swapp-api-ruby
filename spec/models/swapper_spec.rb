# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe Swapper, type: :model do
  let(:user) { create(:user) }
  
  subject(:swapper) do 
    described_class.new(
      name: 'John',
      surname: 'Smith',
      username: user.username,
      email: user.email,
      date_of_birth: '06-06-1966',
      phone_number: '07712345678',
      address: '6, Street',
      city: 'London',
      country: 'UK',
      rating: 'good',
      user_id: user.id
    )
  end

  let(:second_user) do
    create(
      :user,
      username: 'mariorossi',
      email: 'mariorossi@email.com'
    )
  end

  let(:first_swapper) do
    Swapper.create(
      name: 'John',
      surname: 'Smith',
      username: user.username,
      email: user.email,
      date_of_birth: '06-06-1966',
      phone_number: '07712345678',
      address: '6, Street',
      city: 'London',
      country: 'UK',
      rating: 'good',
      user_id: user.id
    )
  end

  let(:second_swapper) do
    Swapper.create(
      name: 'Mario',
      surname: 'Rossi',
      username: second_user.username,
      email: second_user.email,
      city: 'Rome',
      date_of_birth: '01-01-1970',
      phone_number: '3331234567',
      address: '1, Via Torino',
      country: 'IT',
      rating: 'excellent',
      user_id: second_user.id
    )
  end

  describe 'Validations' do
    context 'valid' do
      it 'is valid with valid attributes' do
        expect(subject).to be_valid
      end
    end
    
    context 'invalid' do
      it 'is not valid without a name' do
        subject.name = nil
        expect(subject).to_not be_valid
      end

      it 'is not valid without a surname' do
        subject.surname = nil
        expect(subject).to_not be_valid
      end
  
      it 'is not valid without an username' do
        subject.username = nil
        expect(subject).to_not be_valid
      end

      it 'is not valid without an email' do
        subject.email = nil
        expect(subject).to_not be_valid
      end
  
      it 'is not valid without a phone_number' do
        subject.phone_number = nil
        expect(subject).to_not be_valid
      end
      
      it 'is not valid without a date_of_birth' do
        subject.date_of_birth = nil
        expect(subject).to_not be_valid
      end
  
      it 'is not valid without an address' do
        subject.address = nil
        expect(subject).to_not be_valid
      end
  
      it 'is not valid without a city' do
        subject.city = nil
        expect(subject).to_not be_valid
      end
  
      it 'is not valid without a country' do
        subject.country = nil
        expect(subject).to_not be_valid
      end
    end
  end

  describe 'Scopes' do
    context 'by_rating' do
      it 'only shows products for the requested swapper' do
        expect(Swapper.by_rating(first_swapper.rating)).to include(first_swapper)
        expect(Swapper.by_rating(first_swapper.rating)).not_to include(second_swapper)
      end
    end

    context 'by_username' do
      it 'only shows products for the requested first_swapper' do
        expect(Swapper.by_username(first_swapper.username)).to include(first_swapper)
        expect(Swapper.by_username(first_swapper.username)).not_to include(second_swapper)
      end
    end

    context 'by_email' do
      it 'only shows products for the requested first_swapper' do
        expect(Swapper.by_email(first_swapper.email)).to include(first_swapper)
        expect(Swapper.by_email(first_swapper.email)).not_to include(second_swapper)
      end
    end

    context 'by_city' do
      it 'only shows products for the requested first_swapper' do
        expect(Swapper.by_city(first_swapper.city)).to include(first_swapper)
        expect(Swapper.by_city(first_swapper.city)).not_to include(second_swapper)
      end
    end

    context 'by_country' do
      it 'only shows products for the requested first_swapper' do
        expect(Swapper.by_country(first_swapper.country)).to include(first_swapper)
        expect(Swapper.by_country(first_swapper.country)).not_to include(second_swapper)
      end
    end
  end
end
