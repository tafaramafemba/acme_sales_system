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
    @products = products.each_with_object({}) { |p, h| h[p.code] = p }
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

# STEP 4: Offer base class using strategy pattern
class Offer
  def apply(items)
    items
  end
end

# STEP 5: Red widget offer implementation
class RedWidgetOffer < Offer
  def apply(items)
    red_widgets = items.select { |i| i.code == 'R01' }
    return items if red_widgets.size < 2

    count = 0
    items.map do |item|
      if item.code == 'R01'
        count += 1
        if count.even?
          Product.new(code: item.code, name: item.name, price: item.price / 2)
        else
          item
        end
      else
        item
      end
    end
  end
end

# STEP 6: Final Basket class as required by the assignment
class Basket
  def initialize(catalogue:, delivery_rule:, offers: [])
    @catalogue = catalogue
    @delivery_rule = delivery_rule
    @offers = offers
    @items = []
  end

  # Adds product by product code
  def add(product_code)
    product = @catalogue.find(product_code)
    raise ArgumentError, "Invalid product code: #{product_code}" unless product

    @items << product
  end

  # Returns total as Float (rounded to 2 decimal places)
  def total
    items_with_offers = @offers.reduce(@items.dup) do |items, offer|
      offer.apply(items)
    end

    subtotal = items_with_offers.sum(&:price)
    delivery = @delivery_rule.delivery_cost(subtotal)

    (subtotal + delivery).round(2)
  end
end

# STEP 7: CLI-style usage example for testing
if __FILE__ == $0

  def run_test(product_codes, expected, catalogue, delivery_rule, offers)
    basket = Basket.new(catalogue: catalogue, delivery_rule: delivery_rule, offers: offers)
    product_codes.each { |code| basket.add(code) }
    total = basket.total
    puts "Products: #{product_codes.join(', ')} => Total: $#{'%.2f' % total} | #{total == expected ? 'PASS' : "FAIL (Expected $#{expected})"}"
  end

  products = [
    Product.new(code: 'R01', name: 'Red Widget', price: 32.95),
    Product.new(code: 'G01', name: 'Green Widget', price: 24.95),
    Product.new(code: 'B01', name: 'Blue Widget', price: 7.95)
  ]

  delivery_rule = DeliveryRule.new([
    { min: 0, max: 50, cost: 4.95 },
    { min: 50, max: 90, cost: 2.95 },
    { min: 90, max: Float::INFINITY, cost: 0.0 }
  ])

  catalogue = Catalogue.new(products)
  offers = [RedWidgetOffer.new]

  run_test(%w[B01 G01], 37.85, catalogue, delivery_rule, offers)
  run_test(%w[R01 R01], 54.37, catalogue, delivery_rule, offers)
  run_test(%w[R01 G01], 60.85, catalogue, delivery_rule, offers)
  run_test(%w[B01 B01 R01 R01 R01], 98.27, catalogue, delivery_rule, offers)
end