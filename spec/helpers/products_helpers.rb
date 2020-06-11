# frozen_string_literal: true

module ProductsHelpers

  def image
    fixture_file_upload(
      Rails.root.join(
        'spec', 
        'fixtures', 
        'files', 
        'image.jpg'
      ),
      'image/jpeg'
    )
  end

  def product_create_params
    {
      product: {
        category: 'Product::Item',
        title: 'BMC Alpenchallenge AC2',
        description: 'Great hybrid bike ideal for commuting',
        swapper_id: swapper.id
      }
    }
  end

  def product_update_params
    {
      product: {
        category: 'Product::Item',
        title: 'BMC Roadmachine 01',
        description: 'Super fast road bike from BMC manifacturer',
        swapper_id: swapper.id
      }
    }
  end

  def product_missing_params
    {
      product: {
        category: 'Product::Item',
        title: '',
        description: 'Great hybrid bike ideal for commuting',
        swapper_id: swapper.id
      }
    }
  end

  def products_show_response
    {
      'object' => {
        'id' => item.id,
        'category' => 'Product::Item',
        'title' => 'BMC Alpenchallenge AC2',
        'description' => 'Great hybrid bike ideal for commuting',
        'up_for_auction' => false,
        'swapper_id' => swapper.id
      }
    }
  end

  def products_create_response
    {
      'object' => {
        'id' => Product.last.id,
        'category' => 'Product::Item',
        'title' => 'BMC Alpenchallenge AC2',
        'description' => 'Great hybrid bike ideal for commuting',
        'up_for_auction' => false,
        'swapper_id' => swapper.id
      }
    }
  end

  def products_update_response
    {
      'object' => {
        'id' => item.id,
        'category' => 'Product::Item',
        'title' => 'BMC Roadmachine 01',
        'description' => 'Super fast road bike from BMC manifacturer',
        'up_for_auction' => false,
        'swapper_id' => swapper.id
      }
    }
  end
end
