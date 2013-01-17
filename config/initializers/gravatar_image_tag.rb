# config/initializers/gravatar_image_tag.rb
GravatarImageTag.configure do |config|
  config.default_image = :identicon   # Set this to use your own default gravatar image rather then serving up Gravatar's default image [ 'http://example.com/images/default_gravitar.jpg', :identicon, :monsterid, :wavatar, 404 ].
  config.rating        = 'X'   # Set this if you change the rating of the images that will be returned ['G', 'PG', 'R', 'X']. Gravatar's default is G
  config.secure        = false # Set this to true if you require secure images on your pages.
end
