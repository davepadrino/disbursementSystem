require 'rails_helper'

RSpec.describe CommissionCalculator, type: :service do
  describe '#calculate' do
    it 'calculates 1% for orders below 50€' do
      calculator = CommissionCalculator.new(49.99)
      expect(calculator.calculate).to be_within(0.01).of(0.50)
    end

    it 'calculates 0.95% for orders between 50€ and 300€' do
      calculator = CommissionCalculator.new(100)
      expect(calculator.calculate).to be_within(0.01).of(0.95)
    end

    it 'calculates 0.85% for orders of 300€ or more' do
      calculator = CommissionCalculator.new(300)
      expect(calculator.calculate).to be_within(0.01).of(2.55)
    end

    it 'returns max of 2 decimal places' do
      calculator = CommissionCalculator.new(123.456)
      expect(calculator.calculate).to eq(1.17)
    end
  end
end
