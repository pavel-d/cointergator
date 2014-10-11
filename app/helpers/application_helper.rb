module ApplicationHelper
  def glyphicon(name, text: nil, before_text: nil)
    "#{before_text} <span class=\"glyphicon #{name}\"></span> #{text}".html_safe
  end
end
