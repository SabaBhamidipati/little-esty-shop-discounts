class InvoiceItem < ApplicationRecord
  enum status: { 'pending' => 0, 'packaged' => 1, 'shipped' => 2 }

  belongs_to :invoice
  belongs_to :item
  has_one :merchant, through: :item
  has_many :bulk_discounts, through: :merchant
  validates_presence_of :status

  def self.incomplete_inv
    where(status: %w[pending packaged])
      .order(:created_at)
  end

  def discounted_revenue
    if highest_qualified_discount
    (quantity * unit_price) * (1 - (highest_qualified_discount.percentage / 100.0))
    else
    (quantity * unit_price)
    end
  end

  def highest_qualified_discount
    bulk_discounts.where("threshold <= #{self.quantity}").order(percentage: :desc).first
  end
end
