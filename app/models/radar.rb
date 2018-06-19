class Radar < ApplicationRecord
  mount_uploader :cappi, RadarCappiUploader
  mount_uploader :cmaxdbz, RadarCmaxdbzUploader
  mount_uploader :eht, RadarEhtUploader
  mount_uploader :pac, RadarPacUploader
  mount_uploader :zhail, RadarZhailUploader
  mount_uploader :hshear, RadarHshearUploader
end
