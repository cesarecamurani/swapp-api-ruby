# frozen_string_literal: true

class ProductsController < ApplicationController
  include ProductsHelper

  before_action :find_product, only: :show
  before_action :find_product_for_swapper, only: %i[
    update 
    destroy 
    upload_images 
    remove_image
  ]
  before_action :find_products, only: :index
  before_action :find_products_for_swapper, only: :summary
  before_action :find_attachment, only: :remove_image

  def index
    present_product(@products, :ok)
  end

  def summary
    present_product(@products, :ok)
  end

  def show
    present_product(@product, :ok)
  end

  def create
    @product = Product.new(product_params)
    present_product(@product, :created) if @product.save!
  end

  def update
    present_product(@product, :ok) if @product.update!(product_params)
  end

  def destroy
    head :no_content if @product.destroy!
  end

  def upload_images
    return unless params[:images].presence
    head :ok if @product.images.attach(params[:images])
  end

  def remove_image
    return unless @product.images.attached? && params[:image_id].presence
    head :no_content if @attachment.purge
  end
end
