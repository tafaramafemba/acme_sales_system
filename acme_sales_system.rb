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

# STEP 3: Delivery rule thresholds by subtotal
class DeliveryRule
  def initialize(thresholds)
    # thresholds: [{ min: 0, max: 50, cost: 4.95 }, ...]
    @thresholds = thresholds
  end

  def delivery_cost(subtotal)
    rule = @thresholds.find { |r| subtotal >= r[:min] && subtotal < r[:max] } || { cost: 0.0 }
    rule[:cost]
  end
end