class Order < ApplicationRecord
  self.primary_key = :id
  
  belongs_to :merchant
  belongs_to :disbursement, optional: true

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :created_at, presence: true
  validates :commission_fee, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  before_save :round_values

  private

  def round_values
    self.amount = amount.round(2)
  end
end
