require 'rails_helper'

RSpec.describe 'Bulk Discount Index', type: :feature do
  before :each do
      @merchant = Merchant.create!(name: 'Saba')
      @merchant_2 = Merchant.create!(name: 'Elena')
      @discount_20 = BulkDiscount.create!(percentage: 20, threshold: 10, merchant_id: @merchant.id)
      @discount_10 = BulkDiscount.create!(percentage: 10, threshold: 5, merchant_id: @merchant.id)
      @discount_20 = BulkDiscount.create!(percentage: 30, threshold: 15, merchant_id: @merchant.id)
  end

  it 'should display discounts for merchant including percentage and threshold' do
    visit (merchant_bulk_discounts_path(@merchant))
# save_and_open_page
    expect(page).to have_content("Discounts")
    expect(page).to_not have_content("#{@merchant_2.name}'s Discounts")

    within "#id-#{@discount_20.id}" do
      expect(page).to have_content("Percentage: 20%")
      expect(page).to have_content("Threshold: 10 items")
    end

    within "#id-#{@discount_10.id}" do
      expect(page).to have_content("Percentage: 10%")
      expect(page).to have_content("Threshold: 5 items")
    end

    within "#id-#{@discount_30.id}" do
      expect(page).to have_content("Percentage: 30%")
      expect(page).to have_content("Threshold: 15 items")
    end
  end
end
