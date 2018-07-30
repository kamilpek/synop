class Radar < ApplicationRecord
  mount_uploader :cappi, RadarCappiUploader
  mount_uploader :cmaxdbz, RadarCmaxdbzUploader
  mount_uploader :eht, RadarEhtUploader
  mount_uploader :pac, RadarPacUploader
  mount_uploader :zhail, RadarZhailUploader
  mount_uploader :hshear, RadarHshearUploader
  mount_uploader :sri, RadarSriUploader
  mount_uploader :rtr, RadarRtrUploader

  before_destroy :remember_id
  after_destroy :remove_id_directory

  protected

  def remember_id
    @id = id
  end

  def remove_id_directory
    FileUtils.remove_dir("#{Rails.root}/public/uploads/radar/cappi/#{@id}", :force => true)
    FileUtils.remove_dir("#{Rails.root}/public/uploads/radar/cappi/#{@id}", :force => true)
    FileUtils.remove_dir("#{Rails.root}/public/uploads/radar/cmaxdbz/#{@id}", :force => true)
    FileUtils.remove_dir("#{Rails.root}/public/uploads/radar/eht/#{@id}", :force => true)
    FileUtils.remove_dir("#{Rails.root}/public/uploads/radar/hshear/#{@id}", :force => true)
    FileUtils.remove_dir("#{Rails.root}/public/uploads/radar/pac/#{@id}", :force => true)
    FileUtils.remove_dir("#{Rails.root}/public/uploads/radar/sri/#{@id}", :force => true)
    FileUtils.remove_dir("#{Rails.root}/public/uploads/radar/zhail/#{@id}", :force => true)
    FileUtils.remove_dir("#{Rails.root}/public/uploads/radar/rtr/#{@id}", :force => true)
  end
end
