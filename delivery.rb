require 'net/http'
require 'uri'
require 'json'

class Delivery
  def initialize(weight, length, width, height, distance)
    @weight = weight
    @length = length
    @width = width
    @height = height
    @distance = distance
  end

  def calculate_price
    volume = (@length * @width * @height) / 1000000
    price_per_km = 0

    if volume < 1
      price_per_km = 1
    elsif volume >= 1 && @weight <= 10
      price_per_km = 2
    elsif volume >= 1 && @weight > 10
      price_per_km = 3
    end

    price = (price_per_km * @distance)

    return {
      weight: @weight,
      length: @length,
      width: @width,
      height: @height,
      distance: @distance,
      price: price
    }
  end
end

def fetch_distance(from, to)
  api_key = 'tqo5ppQiXJkSamQRVxnWGZu9Cd6SrH7IPrA3I6mxfKc04vIeUwQLR5UpmGEo4Nkn'
  url = URI("https://api.distancematrix.ai/maps/api/distancematrix/json?origins=#{URI.encode_www_form_component(from)}&destinations=#{URI.encode_www_form_component(to)}&key=#{api_key}")

  response = Net::HTTP.get(url)
  data = JSON.parse(response)

  if data['rows'][0]['elements'][0]['status'] == 'OK'
    distance_meters = data['rows'][0]['elements'][0]['distance']['value']
    distance_km = distance_meters / 1000
    return distance_km
  else
    raise "Ошибка получения расстояния: #{data}"
  end
end