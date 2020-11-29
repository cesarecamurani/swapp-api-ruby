# frozen_string_literal: true

class SwappersController < ApplicationController
  include SwappersHelper

  before_action :find_swapper, only: %i[
    show
    update
    destroy
    upload_avatar
    remove_avatar
  ]

  def index
    find_swappers

    present_swapper(@swappers, :ok)
  end

  def show
    present_swapper(@swapper, :ok)
  end

  def create
    @swapper = Swapper.new(swapper_params)

    present_swapper(@swapper, :created) if @swapper.save!
  end

  def update
    present_swapper(@swapper, :ok) if @swapper.update!(swapper_params)
  end

  def destroy
    head :no_content if @swapper.destroy!
  end

  def upload_avatar
    return unless params[:avatar].presence

    head :ok if @swapper.avatar.attach(params[:avatar])
  end

  def remove_avatar
    return unless @swapper.avatar.attached?

    head :no_content if @swapper.avatar.attachment.purge
  end
end
