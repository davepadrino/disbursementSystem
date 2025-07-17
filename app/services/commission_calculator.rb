class CommissionCalculator
  def initialize(amount)
    @amount = amount.to_f
  end

  def calculate
    fee = if @amount < 50
      @amount * 0.01
    elsif @amount >= 50 && @amount < 300
      @amount * 0.0095
    else
      @amount * 0.0085
    end

    fee.round(2)
  end
end
