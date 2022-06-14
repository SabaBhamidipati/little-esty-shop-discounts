require 'rails_helper'

RSpec.describe 'Bulk Discount Index', type: :feature do
  before :each do
      @merchant = Merchant.create!(name: 'Saba')
      @merchant_2 = Merchant.create!(name: 'Elena')
      @discount_20 = BulkDiscount.create!(percentage: 20, threshold: 10, merchant_id: @merchant.id)
      @discount_10 = BulkDiscount.create!(percentage: 10, threshold: 5, merchant_id: @merchant.id)
      @discount_30 = BulkDiscount.create!(percentage: 30, threshold: 15, merchant_id: @merchant.id)
  end

  it 'should display discounts for merchant including percentage and threshold' do
    visit (merchant_bulk_discounts_path(@merchant_2))
    expect(page).to_not have_content("Percentage")
    expect(page).to_not have_content("Threshold")

    visit (merchant_bulk_discounts_path(@merchant))
    expect(page).to have_content("#{@merchant.name}'s Discounts")
    expect(page).to_not have_content("#{@merchant_2.name}'s Discounts")

    within "#id-#{@discount_20.id}" do
      expect(page).to have_content("Percentage: 20%")
      expect(page).to have_content("Threshold: 10 items")
      expect(page).to have_link("Percentage: #{@discount_20.percentage}")
    end

    within "#id-#{@discount_10.id}" do
      expect(page).to have_content("Percentage: 10%")
      expect(page).to have_content("Threshold: 5 items")
      expect(page).to have_link("Percentage: #{@discount_10.percentage}")
    end

    within "#id-#{@discount_30.id}" do
      expect(page).to have_content("Percentage: 30%")
      expect(page).to have_content("Threshold: 15 items")
      expect(page).to have_link("Percentage: #{@discount_30.percentage}")
    end
  end

  it 'displays a link to create a new discount' do
    visit (merchant_bulk_discounts_path(@merchant))
    expect(page).to_not have_content("Percentage: 40%")
    expect(page).to_not have_content("Threshold: 25 items")

    within("#link-to-create-discount") do
      expect(page).to have_link("Create Discount")
      click_on "Create Discount"
    end

    expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant))
  end

  it 'displays delete button for each discount' do
    visit (merchant_bulk_discounts_path(@merchant))
    expect(page).to have_content("Percentage: 20%")

    within "#id-#{@discount_10.id}" do
      expect(page).to have_content("Percentage: 10%")
      expect(page).to have_content("Threshold: 5 items")
      click_link("Remove: #{@discount_10.id}")

      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant))
      expect(page).to_not have_content("Percentage: 10%")
      expect(page).to_not have_content("Threshold: 5 items")
    end

    expect(page).to have_content("Percentage: 20%")
  end
end
