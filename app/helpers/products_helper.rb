module ProductsHelper
  def categories_ordered
    Category.order(:name).map{|c| [c.name, c.id]}
  end

  def truncate_info info
    info.truncate(Settings.product_information.truncate, separator: " ")
  end

  def load_comments product
    product.comments.order(created_at: :desc)
  end
end
