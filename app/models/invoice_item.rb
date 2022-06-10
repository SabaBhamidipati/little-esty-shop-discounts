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
end
