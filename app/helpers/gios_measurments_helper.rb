module GiosMeasurmentsHelper

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
  
end
