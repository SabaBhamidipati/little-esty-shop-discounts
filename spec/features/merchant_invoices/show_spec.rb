require 'rails_helper'

RSpec.describe 'Merchant Invoice Show page' do
  before :each do
    @merchant = Merchant.create!(name: 'Brylan')
    @item_1 = @merchant.items.create!(name: 'Pencil', unit_price: 500, description: 'Writes things.')
    @item_2 = @merchant.items.create!(name: 'Pen', unit_price: 400, description: 'Writes things, but dark.')
    @item_3 = @merchant.items.create!(name: 'Marker', unit_price: 400,
                                      description: 'Writes things, but dark, and thicc.')

    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Ondricka')
    @invoice_1 = @customer_1.invoices.create!(status: 'completed',
                                              created_at: 'Wed, 01 Jan 2022 21:20:02 UTC +00:00')
    @invoice_7 = @customer_1.invoices.create!(status: 'completed')
    @invoice_item_1 = @item_1.invoice_items.create!(invoice_id: @invoice_1.id, quantity: 3, unit_price: 400, status: 'packaged',
                                                    created_at: Time.parse('2012-03-27 14:54:09 UTC'))
    @invoice_item_2 = @item_2.invoice_items.create!(invoice_id: @invoice_7.id, quantity: 5, unit_price: 375, status: 'pending',
                                                    created_at: Time.parse('2012-03-28 14:54:09 UTC'))
    @invoice_item_3 = @item_2.invoice_items.create!(invoice_id: @invoice_1.id, quantity: 1, unit_price: 375, status: 'shipped',
                                                  created_at: Time.parse('2012-03-28 14:54:09 UTC'))
    @discount_20 = BulkDiscount.create!(percentage: 20, threshold: 5, merchant_id: @merchant.id)
  end

  it 'displays the invoice information in the show page', :vcr do
    visit merchant_invoice_path(@merchant, @invoice_1)

    within "#invoice-header-#{@invoice_1.id}" do
      expect(page).to have_content("Invoice ##{@invoice_1.id}")
    end

    within "#invoice-#{@invoice_1.id}" do
      expect(page).to have_content('Status: completed')
      expect(page).to have_content('Created on: Saturday, January 01, 2022 ')
      expect(page).to have_content('Joey Ondricka')
    end
  end

  it 'displays the invoice items information', :vcr do
    visit merchant_invoice_path(@merchant, @invoice_1)

    within "#invoice-items-#{@invoice_item_1.id}" do
      expect(page).to have_content('Pencil')
      expect(page).to have_content('3')
      expect(page).to have_content('500')
      expect(page).to have_content('packaged')
    end
  end

  it 'displays the total revenue of the items on the invoice', :vcr do
    visit merchant_invoice_path(@merchant, @invoice_1)

    within "#invoice-#{@invoice_1.id}" do
      expect(page).to have_content('Total Revenue: $15.75')
    end
  end

  it 'can update the status of a invoice item', :vcr do
    visit merchant_invoice_path(@merchant, @invoice_1)
    # invoice item 1
    within "#invoice-items-#{@invoice_item_1.id}" do
      expect(page).to have_content('packaged')
      select('shipped')
      click_on('Update Item Status')
    end

    expect(current_path).to eq(merchant_invoice_path(@merchant, @invoice_1))
    within "#invoice-items-#{@invoice_item_1.id}" do
      expect(page).to have_content('shipped')
    end
    # invoice item 3
    within "#invoice-items-#{@invoice_item_3.id}" do
      expect(page).to have_content('shipped')
      select('pending')
      click_on('Update Item Status')
    end

    expect(current_path).to eq(merchant_invoice_path(@merchant, @invoice_1))

    within "#invoice-items-#{@invoice_item_3.id}" do
      expect(page).to have_content('pending')
    end
  end

  it 'can update the status of a invoice item', :vcr do
    visit merchant_invoice_path(@merchant, @invoice_1)
    # invoice item 1
    within "#invoice-items-#{@invoice_item_3.id}" do
      expect(page).to have_content('shipped')
      select('packaged')
      click_on('Update Item Status')
    end

    expect(current_path).to eq(merchant_invoice_path(@merchant, @invoice_1))
    within "#invoice-items-#{@invoice_item_3.id}" do
      expect(page).to have_content('packaged')
    end
  end

  it 'can display discounted revenue' do
    visit merchant_invoice_path(@merchant, @invoice_7)

    within "#invoice-#{@invoice_7.id}" do
      expect(page).to have_content("Discounted Revenue: $15.0")
    end
  end

  it 'does not display discounted revenue if no discounts applied' do
    visit merchant_invoice_path(@merchant, @invoice_1)

    within "#invoice-#{@invoice_1.id}" do
      expect(page).to_not have_content("Discounted Revenue")
    end
  end

  it 'can display link to discount page if item is eligible' do
    visit merchant_invoice_path(@merchant, @invoice_7)

    within "#invoice-items-#{@invoice_item_2.id}" do
      click_on "Discount: #{@discount_20.id}"
      expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @discount_20))
    end
  end
end
