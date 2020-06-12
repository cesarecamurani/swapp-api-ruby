# frozen_string_literal: true

module SwappRequestsHelper
  extend ActiveSupport::Concern

  private

  def find_swapp_request
    @swapp_request ||= all_swapp_requests&.find_by(id: params[:id])
    head :not_found unless @swapp_request
  end

  def find_swapp_requests
    @swapp_requests = all_swapp_requests
    @swapp_requests = sent_scope(@swapp_requests)
    @swapp_requests = received_scope(@swapp_requests)
    @swapp_requests = status_scope(@swapp_requests)
    @swapp_requests = @swapp_requests.to_a
  end

  def sent_scope(scope)
    params[:sent].presence ? sent_swapp_requests : scope
  end

  def received_scope(scope)
    params[:received].presence ? received_swapp_requests : scope
  end

  def status_scope(scope)
    (status = params[:status].presence) ? scope.by_status(status) : scope
  end

  def all_swapp_requests
    sent_swapp_requests&.union(received_swapp_requests)
  end

  def sent_swapp_requests
    current_swapper&.swapp_requests
  end

  def received_swapp_requests
    SwappRequest.received(current_swapper&.id)
  end

  def present_swapp_request(object, status)
    present(object, status: status, serializer: 'Serializer::SwappRequest')
  end

  def swapp_request_params
    params.require(:swapp_request).permit(
      :status,
      :swapper_id,
      :offered_product_id,
      :requested_product_id,
      :req_product_owner_id
    )
  end
end
