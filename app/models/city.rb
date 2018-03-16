class City < ApplicationRecord

  def number
    "#{province}#{county}#{commune}#{genre}"
  end

  geocoded_by :name
  after_validation :geocode
end
