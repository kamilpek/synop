desc "Delete old records from measurements and forecasts. "
task :delete_old => :environment do
  delete = build_delete_old
  if delete.nil?
    puts "Something is wrong."
  else
    puts "Successfull delete."
  end
end

def build_delete_old
  print "Delete begining.\n"
  @measurements = Measurement.where('created_at < ?', 1.week.ago)
  @forecasts = Forecast.where('created_at < ?', 1.week.ago)
  @measurements.delete_all
  @forecasts.delete_all
end
