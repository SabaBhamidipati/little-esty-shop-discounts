require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  context 'relationships' do
    it { should belong_to :merchant }
    it { should have_many(:items).through(:merchant) }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  context 'validations' do
    it { should validate_presence_of :threshold }
    it { should validate_numericality_of :threshold }
    it { should validate_presence_of :percentage }
    it { should validate_numericality_of :percentage }
  end
end
