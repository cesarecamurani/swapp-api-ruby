# frozen_string_literal: true

class SwappRequestsController < ApplicationController
  before_action :find_swapp_requests, only: :index
  before_action :find_swapp_request, only: %i[ 
    show
    destroy
    accept_swapp_request
    reject_swapp_request
  ]

  def index
    present_swapp_request(@swapp_requests, :ok)
  end

  def show
    present_swapp_request(@swapp_request, :ok)
  end

  def create
    @swapp_request = SwappRequest.new(swapp_request_params)
    present_swapp_request(@swapp_request, :created) if @swapp_request.save!
  end

  def destroy
    head :no_content if @swapp_request.destroy! 
  end

  def accept_swapp_request
    return unless @swapp_request.initial?
    if @swapp_request.update!(status: 'accepted')
      present_swapp_request(@swapp_request, :ok)
    end
  end

  def reject_swapp_request
    return unless @swapp_request.initial?
    if @swapp_request.update!(status: 'rejected')
      present_swapp_request(@swapp_request, :ok)
    end
  end

  private

  def find_swapp_request
    @swapp_request ||= all_swapp_requests.find_by(id: params[:id])
    head :not_found unless @swapp_request
  end

  def find_swapp_requests
    @swapp_requests ||= if params[:received].presence
      received_swapp_requests.to_a
    elsif params[:sent].presence
      sent_swapp_requests.to_a
    elsif params[:status].presence
      swapp_requests_by_status(params[:status])
    else
      all_swapp_requests.to_a
    end
  end

  def all_swapp_requests
    sent_swapp_requests.union(received_swapp_requests)
  end

  def sent_swapp_requests
    current_swapper.swapp_requests
  end

  def received_swapp_requests
    SwappRequest.received(current_swapper.id)
  end

  def swapp_requests_by_status(status)
    all_swapp_requests.by_status(status).to_a
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
