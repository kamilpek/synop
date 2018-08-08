module AlertsHelper
  
  def show_author(user)
    if author = User.find(user)
      first_name = author.first_name
      last_name = author.last_name
      first_name + " " + last_name
    else
      "b/d"
    end
  end

  def show_level(level)
    if level == 1
      return "Stopień 1. – żółty"
    elsif level == 2
      return "Stopień 2. – pomarańczowy"
    elsif level == 3
      return "Stopień 3. – czerwony"
    end
  end

  def show_status(status)
    if status == 1
      "Aktywny"
    elsif status == 0
      "Nieaktywny"
    elsif status == 2
      "Anulowany"
    else
      "b/d"
    end
  end

end
