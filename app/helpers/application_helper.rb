module ApplicationHelper
  def gravatar_url_for(email, options = {})
    url = "http://www.gravatar.com/avatar/" + Digest::MD5.hexdigest(email) + "?s=#{options[:size]||50}"
    url_for(url)
  end
end