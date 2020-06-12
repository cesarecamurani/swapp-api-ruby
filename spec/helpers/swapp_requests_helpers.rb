# frozen_string_literal: true

module SwappRequestsHelpers

  def swapp_request_create_params
    {
      swapp_request: {
        status: 'initial',
        swapper_id: swapper.id,
        offered_product_id: offered_item.id,
        requested_product_id: requested_item.id,
        req_product_owner_id: req_product_owner.id
      }
    }
  end

  def swapp_request_missing_params
    {
      swapp_request: {
        status: 'initial',
        swapper_id: '',
        offered_product_id: offered_item.id,
        requested_product_id: requested_item.id,
        req_product_owner_id: req_product_owner.id
      }
    }
  end

  def swapp_requests_show_response
    {
      'object' => {
        'id' => swapp_request.id,
        'status' => 'initial',
        'swapper_id' => swapper.id,
        'offered_product_id' => offered_item.id,
        'requested_product_id' => requested_item.id,
        'req_product_owner_id' => req_product_owner.id
      }
    }
  end

  def swapp_requests_create_response
    {
      'object' => {
        'id' => SwappRequest.last.id,
        'status' => 'initial',
        'swapper_id' => swapper.id,
        'offered_product_id' => offered_item.id,
        'requested_product_id' => requested_item.id,
        'req_product_owner_id' => req_product_owner.id
      }
    }
  end
end
