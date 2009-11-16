# Code has a mix of places where objects are used (e.g. Price) and places where they aren't (e.g. storing the product quantities in an items hash in Terminal).  I tried to use good design without overdesigning things.  As the logic got more complicated, several more objects would naturally appear.  

require File.dirname(__FILE__) + "/util"

class Price
  attr_accessor :quantity, :unit_price
  include FromHash
  def total_price
    quantity.to_f * unit_price
  end
end

# Holds all the possible prices for a given product
class Product
  def prices
    @prices ||= []
  end
  def add_price(unit_price, quantity=1)
    prices << Price.new(:unit_price => unit_price, :quantity => quantity)
  end
  
  # find the prices where we have enough quantity to qualify, then pick the one with the lowest unit price
  # determine the total for that price's quantity, then add that to the total for the remaining quantity.
  #
  # This code certainly is not as efficient as it could be.  Optimizations could be made if needed.  
  # Code could also go in its own object, but I decided against it so far
  def price_for_quantity(qty)
    raise "cannot determine price for negative quantity" if qty < 0
    return 0 if qty == 0
    matching_price = prices.select { |x| x.quantity <= qty }.sort_by { |x| x.unit_price }.first
    remaining_quantity = qty - matching_price.quantity
    matching_price.total_price + price_for_quantity(remaining_quantity)
  end
end 

# Used to calculate the total cost of N qty of one product.  
class Scanner
  def products
    @products ||= Hash.new { |h,k| h[k] = Product.new }
  end
  def add_price(product_name,unit_price,quantity=1)
    products[product_name].add_price(unit_price,quantity)
  end
  def price_for_quantity(product_name, qty)
    products[product_name].price_for_quantity(qty)
  end
end

# Tracks what items have been scanned, then uses the Scanner to determine the total price
class Terminal
  attr_accessor :scanner
  include FromHash
  def add_price(*args)
    scanner.add_price(*args)
  end
  def items
    @items ||= Hash.new { |h,k| h[k] = 0 }
  end
  def clear_items!
    @items = Hash.new { |h,k| h[k] = 0 }
  end
  def scan(product_name,qty=1)
    items[product_name] += qty
  end
  def total
    items.map { |product_name,qty| scanner.price_for_quantity(product_name, qty) }.sum 
  end
end