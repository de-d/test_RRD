class OrdersController < ApplicationController
  def new
    @order = Order.new
  end

  def create
    raw_params = order_params.to_h
    raw_params[:weight] = raw_params[:weight].to_i
    raw_params[:length] = raw_params[:length].to_i
    raw_params[:width] = raw_params[:width].to_i
    raw_params[:height] = raw_params[:height].to_i

    @order = Order.new(raw_params)

    calculator = DeliveryCalculator.new(
      weight: raw_params[:weight],
      length: raw_params[:length],
      width: raw_params[:width],
      height: raw_params[:height],
      from: raw_params[:from],
      to: raw_params[:to]
    )

    result = calculator.call
    @order.distance = result[:distance]
    @order.price = result[:price]

    if @order.save
      redirect_to @order, notice: "Заказ был успешно создан."
    else
      render :new
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  private

  def order_params
    params.require(:order).permit(
      :first_name, :last_name, :middle_name, :phone, :email,
      :weight, :length, :width, :height, :from, :to
    )
  end
end
