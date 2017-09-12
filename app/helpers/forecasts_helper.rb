module ForecastsHelper

  def cardinals(degrees)
    degrees = degrees.to_i
    if degrees.between?(0, 22)
      return "Północny"
    elsif degrees.between?(337, 360)
      return "Północny"
    elsif degrees.between?(22, 67)
      return "Północno Wschodni"
    elsif degrees.between?(67, 112)
      return "Wschodni"
    elsif degrees.between?(112, 157)
      return "Południowo Wschodni"
    elsif degrees.between?(157, 202)
      return "Południowy"
    elsif degrees.between?(202, 247)
      return "Południowo Zachodni"
    elsif degrees.between?(247, 292)
      return "Zachodni"
    elsif degrees.between?(292, 337)
      return "Północno Zachodni"
    else
      return "Brak Danych"
    end
  end
end
