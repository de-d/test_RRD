require "net/http"
require "uri"
require "json"
require "httparty"

class DeliveryCalculator
  API_KEY = "tqo5ppQiXJkSamQRVxnWGZu9Cd6SrH7IPrA3I6mxfKc04vIeUwQLR5UpmGEo4Nkn"

  def initialize(weight:, length:, width:, height:, from:, to:)
    @weight = weight
    @length = length
    @width = width
    @height = height
    @from = from
    @to = to
  end

  def call
    distance = fetch_distance
    price = calculate_price(distance)

    {
      weight: @weight,
      length: @length,
      width: @width,
      height: @height,
      distance: distance,
      price: price
    }
  end

  private

  def fetch_distance
    if @from.blank? || @to.blank?
      raise "Ошибка: 'Откуда' или 'Куда' не могут быть пустыми"
    end

    url = URI("https://api.distancematrix.ai/maps/api/distancematrix/json?origins=#{URI.encode_www_form_component(@from)}&destinations=#{URI.encode_www_form_component(@to)}&key=#{API_KEY}")
    response = HTTParty.get(url)

    if response.success?
      data = JSON.parse(response.body)
      if data["rows"] && data["rows"][0] && data["rows"][0]["elements"] && data["rows"][0]["elements"][0] && data["rows"][0]["elements"][0]["distance"]
        data["rows"][0]["elements"][0]["distance"]["value"] / 1000
      else
        raise "Ошибка в формате данных от API. Ответ: #{data}"
      end
    else
      raise "Ошибка при запросе к API: #{response.code} - #{response.body}"
    end
  end

  def calculate_price(distance)
    volume = (@length * @width * @height) / 1000000
    price_per_km = 0

    if volume < 1
      price_per_km = 1
    elsif volume >= 1 && @weight <= 10
      price_per_km = 2
    elsif volume >= 1 && @weight > 10
      price_per_km = 3
    end

    (distance * price_per_km).round(2)
  end
end
