module PagesHelper

  def get_index_level(level)
    if level == 0
      "Bardzo dobry"
    elsif level == 1
      "Dobry"
    elsif level == 2
      "Umiarkowany"
    elsif level == 3
      "Dostateczny"
    elsif level == 4
      "Zły"
    elsif level == 5
      "Bardzo zły"
    else
      "b/d"
    end
  end

  def get_index_class(level)
    if level == 0
      "alert-success"
    elsif level == 1
      "alert-success"
    elsif level == 2
      "alert-warning"
    elsif level == 3
      "alert-danger"
    elsif level == 4
      "alert-danger"
    elsif level == 5
      "alert-danger"
    else
      "alert-dark"
    end
  end

  def show_level_short(level)
    if level == 1
      return "Stopień 1."
    elsif level == 2
      return "Stopień 2."
    elsif level == 3
      return "Stopień 3."
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
