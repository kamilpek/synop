desc "Import metar data from ogimet.net. "
task :import_ogimet => :environment do
  import = build_import_ogimet
  if import.nil?
    puts "Something is wrong."
  else
    puts "Successfull import."
  end
end

def build_import_ogimet
  print "Import begining.\n"
  ogimet = `Rscript lib/tasks/ogimet.R`
end
