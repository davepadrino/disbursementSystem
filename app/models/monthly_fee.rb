class MonthlyFee < ApplicationRecord
  self.primary_key = :id

  belongs_to :merchant

  validates :month, presence: true
  validates :total_fees, :charged_fee,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 }

  before_save :round_values

  private

  def round_values
    self.total_fees = total_fees.round(2)
    self.charged_fee = charged_fee.round(2)
  end
end
