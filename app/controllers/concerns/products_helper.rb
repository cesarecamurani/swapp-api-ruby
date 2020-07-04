# frozen_string_literal: true

module ProductsHelper
  extend ActiveSupport::Concern

  private

  def find_attachment
    @attachment ||= @product.images.find_by(id: params[:image_id])
    head :not_found unless @attachment
  end

  def find_product_for_swapper
    @product ||= products&.find_by(id: params[:id])
    head :not_found unless @product
  end

  def find_products_for_swapper
    @products ||= products&.to_a || []
  end

  def find_product
    @product ||= Product.find_by(id: params[:id])
    head :not_found unless @product
  end

  def find_products
    @products = Product.all
    @products = swapper_id_scope(@products)
    @products = category_scope(@products)
    @products = department_scope(@products)
    @products = @products.to_a
  end

  def swapper_id_scope(scope)
    (swapper_id = params[:swapper_id].presence) ? scope.by_swapper(swapper_id) : scope
  end

  def category_scope(scope)
    (category = params[:category].presence) ? scope.by_category(category) : scope
  end

  def department_scope(scope)
    (department = params[:department].presence) ? scope.by_department(department) : scope
  end

  def products
    current_swapper&.products
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
      :department,
      images: [] 
    )
  end
end

