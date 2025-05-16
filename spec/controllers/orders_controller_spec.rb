require "rails_helper"

RSpec.describe OrdersController, type: :controller do
  describe "POST #create" do
    let(:valid_params) do
      {
        order: {
          first_name: "Руслан",
          last_name: "Эвелонов",
          middle_name: "Ликсович",
          phone: "1234567890",
          email: "test@test.com",
          weight: 10000,
          length: 30000,
          width: 20000,
          height: 15000,
          from: "Краснодар",
          to: "Санкт-Петербург"
        }
      }
    end

    describe "GET #new" do
      it "возвращает успешный ответ и инициализирует новый заказ" do
        get :new
        expect(response).to have_http_status(:ok)
        expect(assigns(:order)).to be_a_new(Order)
      end
    end

    describe "GET #show" do
      it "возвращает заказ по id" do
        order = Order.create!(
          first_name: "Руслан",
          last_name: "Эвелонов",
          middle_name: "Ликсович",
          phone: "1234567890",
          email: "test@test.com",
          weight: 10000,
          length: 30000,
          width: 20000,
          height: 15000,
          from: "Краснодар",
          to: "Санкт-Петербург",
          distance: 1000,
          price: 500
        )
        get :show, params: {id: order.id}
        expect(response).to have_http_status(:ok)
        expect(assigns(:order)).to eq(order)
      end
    end

    it "создаёт заказ и возвращает 302 (редирект)" do
      post :create, params: valid_params
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(order_path(Order.last))
      expect(Order.count).to eq(1)
    end

    it "не создаёт заказ с невалидными параметрами" do
      invalid_params = valid_params.deep_merge(order: {weight: nil})
      post :create, params: invalid_params
      expect(response).to render_template(:new)
      expect(Order.count).to eq(0)
    end

    it "вызывает DeliveryCalculator при валидных параметрах" do
      calculator = instance_double(DeliveryCalculator, call: {distance: 1000, price: 500})
      allow(DeliveryCalculator).to receive(:new).and_return(calculator)
      post :create, params: valid_params
      expect(DeliveryCalculator).to have_received(:new)
      expect(calculator).to have_received(:call)
    end

    it "не вызывает DeliveryCalculator, если заказ невалиден" do
      allow(DeliveryCalculator).to receive(:new)
      invalid_params = valid_params.deep_merge(order: {weight: nil})
      post :create, params: invalid_params
      expect(DeliveryCalculator).not_to have_received(:new)
      expect(response).to render_template(:new)
    end
  end
end
