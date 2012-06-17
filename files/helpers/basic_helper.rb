# coding : utf-8
module BasicHelper
  def copyrights
    from=2012
    year=Time.now.year
    res="&copy; ИВЦ МГИУ "
    res+=year>from ? "#{from}&mdash;#{year}" : from.to_s
    res.html_safe
  end

  def flash_class(level)
    classes=['alert']
    classes << case level
                 when :notice
                   "alert-info"
                 when :success
                   "alert-success"
                 when :error, :alert
                   "alert-error"

               end
    classes
  end
end
