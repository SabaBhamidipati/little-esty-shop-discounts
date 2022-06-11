require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'relationships' do
    it { should belong_to(:invoice) }
    it { should belong_to(:item) }
    it { should have_one(:merchant).through(:item) }
    it { should have_many(:bulk_discounts).through(:merchant)}
  end

  describe 'validations' do
    it { should validate_presence_of(:status) }
  end

  describe 'class methods' do
    it '#incomplete_inv shows invoices that are incomplete' do
      @m1 = Merchant.create!(name: 'Merchant 1')
      @c1 = Customer.create!(first_name: 'Bilbo', last_name: 'Baggins')
      @c2 = Customer.create!(first_name: 'Frodo', last_name: 'Baggins')
      @c3 = Customer.create!(first_name: 'Samwise', last_name: 'Gamgee')

      @item_1 = Item.create!(name: 'Shampoo', description: 'This washes your hair', unit_price: 10, merchant_id: @m1.id)
      @item_2 = Item.create!(name: 'Conditioner', description: 'This makes your hair shiny', unit_price: 8, merchant_id: @m1.id)
      @item_3 = Item.create!(name: 'Brush', description: 'This takes out tangles', unit_price: 5, merchant_id: @m1.id)

      @i1 = Invoice.create!(customer_id: @c1.id, status: 2)
      @i2 = Invoice.create!(customer_id: @c1.id, status: 2)
      @i3 = Invoice.create!(customer_id: @c2.id, status: 2)
      @i4 = Invoice.create!(customer_id: @c3.id, status: 2)

      @ii_1 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0,
                                  created_at: Time.parse('2012-03-27 14:54:09 UTC'))
      @ii_2 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0,
                                  created_at: Time.parse('2013-03-27 14:54:09 UTC'))
      @ii_3 = InvoiceItem.create!(invoice_id: @i2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2,
                                  created_at: Time.parse('2012-03-27 14:54:09 UTC'))
      @ii_4 = InvoiceItem.create!(invoice_id: @i3.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 1,
                                  created_at: Time.parse('2011-03-27 14:54:09 UTC'))

      expect(InvoiceItem.incomplete_inv).to eq([@ii_4, @ii_1, @ii_2])
    end

    it 'calculates discounted revenue if eligible' do
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
      @discount_10 = BulkDiscount.create!(percentage: 10, threshold: 5, merchant_id: @merchant.id)

      expect(@invoice_item_2.discounted_revenue).to eq(1500)
      expect(@invoice_item_2.discounted_revenue).to_not eq(1687.50)
    end
  end
end
