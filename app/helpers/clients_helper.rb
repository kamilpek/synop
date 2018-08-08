module ClientsHelper

  def get_status(status)
    if status == 1
      "Aktywny"
    elsif status == 2
      "Zalega z płatnościami"
    elsif status == 0
      "Nieaktywny"
    else
      "b/d"
    end
  end
  
end
