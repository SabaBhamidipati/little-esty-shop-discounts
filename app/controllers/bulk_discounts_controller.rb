class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    new_discount = @merchant.bulk_discounts.new(discount_params)

    if params[:percentage].empty? || params[:threshold].empty?
      flash[:notice] = "Error: Fields cannot be empty"
      redirect_to new_merchant_bulk_discount_path(@merchant)
    elsif
      !percent_valid? || params[:threshold].to_i < 0
      flash[:notice] = "Error: Please enter positive integer between 1 and 100"
      redirect_to new_merchant_bulk_discount_path(@merchant)
    else
      new_discount.save
      redirect_to merchant_bulk_discounts_path(@merchant)
    end
  end

  def destroy
    bulk_discount = BulkDiscount.find(params[:id])
    bulk_discount.destroy
    redirect_to merchant_bulk_discounts_path(params[:merchant_id])
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def update
  end

  private
  def discount_params
    params.permit(:percentage, :threshold)
  end

  def percent_valid?
    percent_valid
  end

  def percent_valid
    params[:percentage].to_i <= 100 && params[:percentage].to_i > 0
  end
end
