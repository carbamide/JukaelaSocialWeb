module ApplicationHelper
  def title
    base_title = "Jukaela Social"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  def logo
    logo = image_tag("logo.png", :alt => "Jukaela", :class => "round")
  end
end
