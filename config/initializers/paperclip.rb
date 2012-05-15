STORAGE_OPTS = Rails.env == 'production' ?
  {:storage => :s3, :s3_credentials => Rails.root.join('config','s3.yml').to_s, :path => ':attachment/:id/:style/:filename'} :
  {:storage => :filesystem}
