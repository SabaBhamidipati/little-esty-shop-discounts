require 'rails_helper'

RSpec.describe 'Bulk Discount Create', type: :feature do
  before :each do
    @merchant = Merchant.create!(name: 'Saba')
    @merchant_2 = Merchant.create!(name: 'Elena')
    @discount_20 = BulkDiscount.create!(percentage: 20, threshold: 10, merchant_id: @merchant.id)
    @discount_10 = BulkDiscount.create!(percentage: 10, threshold: 5, merchant_id: @merchant.id)
    @discount_30 = BulkDiscount.create!(percentage: 30, threshold: 15, merchant_id: @merchant.id)
  end

  it 'displays error if percent > 100' do
    visit merchant_bulk_discounts_path(@merchant)

    expect(page)
  end
end
