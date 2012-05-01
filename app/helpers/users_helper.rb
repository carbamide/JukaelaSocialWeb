module UsersHelper

  def gravatar_for(user, options = { :size => 50})
    gravatar_image_tag(user.email.downcase, :alt => h(user.name),
    :class => 'gravatar',
    :gravatar => options)
  end

  def quoted_user(username)
    url = '"%s" ' % username
  end

  def unique_modal(id, type)
    id.to_s + type
  end
  
  def link_to_unique_modal(string)
    return_string = '#%s' % string
  end
end
