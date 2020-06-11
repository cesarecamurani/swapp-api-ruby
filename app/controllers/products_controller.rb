# frozen_string_literal: true

class ProductsController < ApplicationController
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

  private

  def find_attachment
    @attachment ||= @product.images.find_by(id: params[:image_id])
    head :not_found unless @attachment
  end

  def find_product_for_swapper
    @product ||= current_swapper.products.find_by(id: params[:id])
    head :not_found unless @product
  end

  def find_product
    @product ||= Product.find_by(id: params[:id])
    head :not_found unless @product
  end

  def find_products_for_swapper
    @products ||= current_swapper.products.to_a || []
  end

  def find_products
    @products = if swapper_id_present?
      Product.by_swapper(@swapper_id).to_a
    elsif category_present?
      Product.by_category(@category).to_a
    else
      Product.all.to_a || []
    end
  end

  def swapper_id_present?
    @swapper_id ||= params[:swapper_id].presence
  end

  def category_present?
    @category ||= params[:category].presence
  end

  def present_product(object, status)
    present(object, status: status, serializer: 'Serializer::Product')
  end

  def product_params
    params.require(:product).permit(
      :category,
      :title,
      :description,
      :swapper_id,
      :up_for_auction,
      images: [] 
    )
  end 
end
