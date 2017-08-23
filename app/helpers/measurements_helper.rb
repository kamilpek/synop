module MeasurementsHelper
  require "#{Rails.root}/lib/calendar.rb"
  def calendar(date = Date.today, &block)
    Calendar.new(self, date, block).table
  end

end
