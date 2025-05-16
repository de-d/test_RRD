require "rails_helper"

RSpec.describe Order, type: :model do
  subject { described_class.new(first_name: "Руслан", last_name: "Эвелонов", middle_name: "Ликсович", phone: "1234567890", email: "test@test.com", weight: 10000, length: 30000, width: 20000, height: 15000, from: "Краснодар", to: "Санкт-Петербург") }

  it "валидна с корректными параметрами" do
    expect(subject).to be_valid
  end

  it "невалидна без веса" do
    subject.weight = nil
    subject.valid?
    expect(subject.errors[:weight]).to include("не может быть пустым")
  end

  it "невалидна без длины" do
    subject.length = nil
    subject.valid?
    expect(subject.errors[:length]).to include("не может быть пустым")
  end

  it "невалидна без адреса отправления" do
    subject.from = nil
    subject.valid?
    expect(subject.errors[:from]).to include("не может быть пустым")
  end

  it "невалидна без адреса назначения" do
    subject.to = nil
    subject.valid?
    expect(subject.errors[:to]).to include("не может быть пустым")
  end

  describe ".ransackable_attributes" do
    it "возвращает список атрибутов для поиска" do
      expect(Order.ransackable_attributes).to include(
        "first_name", "last_name", "middle_name", "phone",
        "email", "weight", "length", "width", "height",
        "from", "to", "distance", "price"
      )
    end
  end
end
