class Merchant < ApplicationRecord
  self.primary_key = :id
   # `dependent: :destroy` for avoiding orphaned records
  has_many :orders, dependent: :destroy
  has_many :disbursements, dependent: :destroy
  has_one :monthly_fees, dependent: :destroy

  enum disbursement_frequency: { daily: 'DAILY', weekly: 'WEEKLY' }

  validates :reference, presence: true, uniqueness: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :live_on, presence: true
  validates :disbursement_frequency, presence: true, inclusion: { in: disbursement_frequencies.keys }
  validates :minimum_monthly_fee, presence: true, numericality: { greater_than_or_equal_to: 0 }

  before_save :round_minimum_fee

  private

  def round_minimum_fee
    self.minimum_monthly_fee = minimum_monthly_fee.round(2)
  end
end
