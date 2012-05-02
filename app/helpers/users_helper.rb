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
  
  def create_new_micropost(content)
    @tempPost = current_user.microposts.build(:content => content, :user_id => current_user.id)
    @tempPost.save
  end
  
  def find_user_from_mention(id)
    temp_user = User.find_by_id(id)
  end
end
