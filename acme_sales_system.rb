# STEP 1: Define Product class
class Product
  attr_reader :code, :name, :price

  def initialize(code:, name:, price:)
    @code = code
    @name = name
    @price = price
  end
end

# STEP 2: Catalogue to look up products by code
class Catalogue
  def initialize(products)
    @products = products.index_by(&:code)
  end

  def find(code)
    @products[code]
  end
end