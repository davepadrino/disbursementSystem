class Disbursement < ApplicationRecord
  self.primary_key = :id
  
  belongs_to :merchant
  has_many :orders, dependent: :nullify

  validates :reference, presence: true, uniqueness: { scope: :merchant_id }
  validates :disbursement_date, presence: true
  validates :total_amount, :total_fees,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 }

  before_save :round_values

  private

  def round_values
    self.total_amount = total_amount.round(2)
    self.total_fees = total_fees.round(2)
  end
end