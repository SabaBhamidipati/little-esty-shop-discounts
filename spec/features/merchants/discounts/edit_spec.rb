require 'rails_helper'

RSpec.describe 'Bulk Discount Index', type: :feature do
  before :each do
      @merchant = Merchant.create!(name: 'Saba')
      @merchant_2 = Merchant.create!(name: 'Elena')
      @discount_20 = BulkDiscount.create!(percentage: 20, threshold: 10, merchant_id: @merchant.id)
      @discount_10 = BulkDiscount.create!(percentage: 10, threshold: 5, merchant_id: @merchant.id)
      @discount_30 = BulkDiscount.create!(percentage: 30, threshold: 15, merchant_id: @merchant.id)

      visit edit_merchant_bulk_discount_path(@merchant, @discount_20)
  end
  it "has prefilled fields" do
    expect(page).to have_field(:percentage, with: '20')
    expect(page).to have_field(:threshold, with: '10')

    expect(page).to_not have_field(:percentage, with: '30')
    expect(page).to_not have_field(:threshold, with: '15')
  end

  it 'displays error if percent > 100' do
      fill_in 'Percentage', with: 200
      fill_in 'Threshold', with: 200
      click_on "Submit"

    expect(page).to have_content("Error: Please enter positive integer between 1 and 100")
    expect(current_path).to_not eq(merchant_bulk_discount_path(@merchant, @discount_20))
    expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant, @discount_20))
  end

  it 'displays error if percent < 0' do
      fill_in 'Percentage', with: -200
      fill_in 'Threshold', with: 200
      click_on "Submit"

    expect(page).to have_content("Error: Please enter positive integer between 1 and 100")
    expect(current_path).to_not eq(merchant_bulk_discount_path(@merchant, @discount_20))
    expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant, @discount_20))
  end

  it 'displays error if percent < 0' do
      fill_in 'Percentage', with: 50
      fill_in 'Threshold', with: -200
      click_on "Submit"

    expect(page).to have_content("Error: Please enter positive integer between 1 and 100")
    expect(current_path).to_not eq(merchant_bulk_discount_path(@merchant, @discount_20))
    expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant, @discount_20))
  end

  it 'displays error if percent blank' do
      fill_in 'Percentage', with: ""
      fill_in 'Threshold', with: 200
      click_on "Submit"

    expect(page).to have_content("Error: Fields cannot be empty")
    expect(current_path).to_not eq(merchant_bulk_discount_path(@merchant, @discount_20))
    expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant, @discount_20))
  end

  it 'displays error if threshold blank' do
    fill_in 'Percentage', with: 50
      fill_in 'Threshold', with: ""
    click_on "Submit"

    expect(page).to have_content("Error: Fields cannot be empty")
    expect(current_path).to_not eq(merchant_bulk_discount_path(@merchant, @discount_20))
    expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant, @discount_20))
  end

  it 'displays error if percent contains letters' do
      fill_in 'Percentage', with: "aaa"
      fill_in 'Threshold', with: -200
      click_on "Submit"

    expect(page).to have_content("Error: Please enter positive integer between 1 and 100")
    expect(current_path).to_not eq(merchant_bulk_discount_path(@merchant, @discount_20))
    expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant, @discount_20))
  end

  it 'displays error if percent contains letters' do
      fill_in 'Percentage', with: 40
      fill_in 'Threshold', with: 245
      click_on "Submit"

    expect(page).to have_content("Percentage: 40%")
    expect(page).to have_content("Threshold: 245 items")
    expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @discount_20))
    expect(current_path).to_not eq(edit_merchant_bulk_discount_path(@merchant, @discount_20))
  end
end
