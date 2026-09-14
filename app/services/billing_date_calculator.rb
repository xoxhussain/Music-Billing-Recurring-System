class BillingDateCalculator
  def initialize(billing_day, date = Date.current)
    @billing_day = billing_day
    @date = date
  end

  def billing_date
    last_day = @date.end_of_month.day
    day = [ @billing_day, last_day ].min

    @date.change(day: day)
  end

  def due_today?
    billing_date == @date
  end
end
