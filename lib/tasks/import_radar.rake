desc "Import Radar. "
task :import_radar => :environment do
  import = build_import_radar
  if import.nil?
    puts "Something is wrong."
  else
    puts "Successfull import."
  end
end

def build_import_radar
  print "Import begining.\n"
  cappi = 'https://meteomodel.pl/radar/cappi.png'
  cmaxdbz = 'https://meteomodel.pl/radar/cmax.png'
  eht = 'https://meteomodel.pl/radar/eht.png'
  pac = 'https://meteomodel.pl/radar/pac.png'
  zhail = 'https://meteomodel.pl/radar/zhail.png'
  hshear = 'https://meteomodel.pl/radar/hshear.png'

  Radar.create!(:remote_cappi_url => cappi,
                :remote_cmaxdbz_url => cmaxdbz,
                :remote_eht_url => eht,
                :remote_pac_url => pac,
                :remote_zhail_url => zhail,
                :remote_hshear_url => hshear)
end
