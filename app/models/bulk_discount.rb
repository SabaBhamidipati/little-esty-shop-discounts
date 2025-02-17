class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  has_many :items, through: :merchant
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items

  validates_presence_of :percentage, :threshold
  validates :percentage, numericality: { in: 1..100 }
  validates :threshold, numericality: { omly_integer: true }
end
