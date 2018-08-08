class Category < ApplicationRecord
  has_many :alert

  mount_uploader :image, CategoryImageUploader
end
