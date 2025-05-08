require 'minitest/autorun'
require_relative 'delivery'

class DeliveryTest < Minitest::Test
  def test_small_volume
    delivery = Delivery.new(5, 50, 50, 50, 100)
    result = delivery.calculate_price
    assert_equal 100, result[:price]
  end

  def test_large_volume_light_weight
    delivery = Delivery.new(5, 100, 100, 100, 200)
    result = delivery.calculate_price
    assert_equal 400, result[:price]
  end

  def test_large_volume_heavy_weight
    delivery = Delivery.new(20, 100, 100, 100, 300)
    result = delivery.calculate_price
    assert_equal 900, result[:price]
  end

  def test_returned_hash_keys
    delivery = Delivery.new(10, 100, 100, 100, 150)
    result = delivery.calculate_price
    expected_keys = [:weight, :length, :width, :height, :distance, :price]
    assert_equal expected_keys, result.keys
  end
end
