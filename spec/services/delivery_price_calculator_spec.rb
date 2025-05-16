require "rails_helper"

RSpec.describe DeliveryCalculator do
  let(:params) do
    {
      weight: 15000,
      length: 10000,
      width: 10000,
      height: 10000,
      from: "Краснодар",
      to: "Санкт-Петербург"
    }
  end

  describe "#call" do
    it "возвращает расстояние и цену при успешном API" do
      stub_response = {
        "rows" => [
          {
            "elements" => [
              {"distance" => {"value" => 100_000}}
            ]
          }
        ]
      }

      allow(HTTParty).to receive(:get).and_return(double(success?: true, body: stub_response.to_json))

      result = described_class.new(**params).call

      expect(result[:distance]).to eq(100)
      expect(result[:price]).to eq(300.0)
    end

    it "возвращает цену с price_per_km = 1, если объём < 1" do
      stub_response = {
        "rows" => [
          {
            "elements" => [
              {"distance" => {"value" => 100_000}}
            ]
          }
        ]
      }

      allow(HTTParty).to receive(:get).and_return(double(success?: true, body: stub_response.to_json))

      small_params = {
        weight: 5,
        length: 10,
        width: 10,
        height: 10,
        from: "Казань",
        to: "Уфа"
      }

      result = described_class.new(**small_params).call
      expect(result[:price]).to eq(100 * 1)
    end

    it "возвращает цену с price_per_km = 2, если объём >= 1 и вес <= 10" do
      stub_response = {
        "rows" => [
          {
            "elements" => [
              {"distance" => {"value" => 50_000}}
            ]
          }
        ]
      }

      allow(HTTParty).to receive(:get).and_return(double(success?: true, body: stub_response.to_json))

      light_params = {
        weight: 10,
        length: 1000,
        width: 1000,
        height: 1000,
        from: "Казань",
        to: "Уфа"
      }

      result = described_class.new(**light_params).call
      expect(result[:price]).to eq(50 * 2)
    end

    it "поднимает ошибку при пустом from или to" do
      expect {
        described_class.new(**params.merge(from: "", to: "")).call
      }.to raise_error("Ошибка: 'Откуда' или 'Куда' не могут быть пустыми")
    end

    it "поднимает ошибку при плохом ответе API" do
      allow(HTTParty).to receive(:get).and_return(double(success?: false, code: 500, body: "Internal Server Error"))

      expect {
        described_class.new(**params).call
      }.to raise_error("Ошибка при запросе к API: 500 - Internal Server Error")
    end

    it "поднимает ошибку при отсутствии данных distance в ответе API" do
      stub_response = {
        "rows" => [
          {
            "elements" => [
              {}
            ]
          }
        ]
      }

      allow(HTTParty).to receive(:get).and_return(double(success?: true, body: stub_response.to_json))

      expect {
        described_class.new(**params).call
      }.to raise_error(/Ошибка в формате данных от API/)
    end
  end
end
