class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    new_discount = @merchant.bulk_discounts.new(discount_params)

    if new_discount.valid?
      new_discount.save
      redirect_to merchant_bulk_discounts_path(@merchant)
    else
      flash[:messages] = new_discount.errors.full_messages
      render :new
    end
  end

  private
  def discount_params
    params.permit(:percentage, :threshold)
  end
end
