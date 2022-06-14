require 'rails_helper'

RSpec.describe 'Bulk Discount Index', type: :feature do
  before :each do
      @merchant = Merchant.create!(name: 'Saba')
      @merchant_2 = Merchant.create!(name: 'Elena')
      @discount_20 = BulkDiscount.create!(percentage: 20, threshold: 10, merchant_id: @merchant.id)
      @discount_10 = BulkDiscount.create!(percentage: 10, threshold: 5, merchant_id: @merchant.id)
      @discount_30 = BulkDiscount.create!(percentage: 30, threshold: 15, merchant_id: @merchant.id)
  end

  it 'displays bulk discount threshold and percentage' do
    visit merchant_bulk_discount_path(@merchant, @discount_20)

    within "#percentage" do
      expect(page).to have_content("Percentage: 20%")
      expect(page).to_not have_content("Percentage: 30%")
    end

    within "#threshold" do
      expect(page).to have_content("Threshold: 10 items")
      expect(page).to_not have_content("Threshold: 15 items")
    end

  end
end
