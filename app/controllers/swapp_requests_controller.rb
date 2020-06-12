# frozen_string_literal: true

class SwappRequestsController < ApplicationController
  include SwappRequestsHelper

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
end
