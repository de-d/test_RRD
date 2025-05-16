class OrdersController < ApplicationController
  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)

    if @order.valid?
      calculator = DeliveryCalculator.new(
        weight: @order.weight,
        length: @order.length,
        width: @order.width,
        height: @order.height,
        from: @order.from,
        to: @order.to
      )

      result = calculator.call
      @order.distance = result[:distance]
      @order.price = result[:price]
    end

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
