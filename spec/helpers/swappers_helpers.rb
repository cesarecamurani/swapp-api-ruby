# frozen_string_literal: true

module SwappersHelpers

  def avatar
    fixture_file_upload(
      Rails.root.join(
        'spec', 
        'fixtures', 
        'files', 
        'avatar.jpg'
      ),
      'image/jpeg'
    )
  end

  def swapper_create_params
    {
      swapper: {
        name: 'Nomen',
        surname: 'Nescio',
        username: user.username,
        email: 'nomennescio@email.com',
        date_of_birth: '06-06-1966',
        phone_number: '07712345678',
        address: '6, Street',
        city: 'Rome',
        country: 'Italy',
        rating: nil,
        user_id: user.id
      }
    }
  end

  def swapper_update_params
    {
      swapper: {
        name: 'Settimio',
        surname: 'Severo',
        username: user.username,
        email: 'settimio@email.com',
        date_of_birth: '06-06-1966',
        phone_number: '07712345678',
        address: '6, Street',
        city: 'Rome',
        country: 'Italy',
        rating: 'good',
        user_id: user.id
      }
    }
  end

  def swapper_missing_params
    {
      swapper: {
        name: '',
        surname: '',
        email: user.email,
        username: user.username,
        date_of_birth: '06-06-1966',
        phone_number: '07712345678',
        address: '6, Street',
        city: 'Rome',
        country: 'Italy',
        rating: 'good',
        user_id: user.id
      }
    }
  end
  
  def swappers_show_response
    {
      'object' => {
        'id' => swapper.id,
        'name' => 'John',
        'surname' => 'Smith',
        'username' => user.username,
        'email' => user.email,
        'phone_number' => '07712345678',
        'date_of_birth' => '06-06-1966',
        'address' => '6, Street',
        'city' => 'London',
        'country' => 'UK',
        'rating' => 'good',
        'user_id' => user.id
      }
    }
  end

  def swappers_create_response
    {
      'object' => {
        'id' => Swapper.last.id,
        'name' => 'Nomen',
        'surname' => 'Nescio',
        'username' => user.username,
        'email' => 'nomennescio@email.com',
        'phone_number' => '07712345678',
        'date_of_birth' => '06-06-1966',
        'address' => '6, Street',
        'city' => 'Rome',
        'country' => 'Italy',
        'rating' => nil,
        'user_id' => user.id
      }
    }
  end

  def swappers_update_response
    {
      'object' => {
        'id' => swapper.id,
        'name' => 'Settimio',
        'surname' => 'Severo',
        'username' => user.username,
        'email' => 'settimio@email.com',
        'phone_number' => '07712345678',
        'date_of_birth' => '06-06-1966',
        'address' => '6, Street',
        'city' => 'Rome',
        'country' => 'Italy',
        'rating' => 'good',
        'user_id' => user.id
      }
    }
  end
end
