class Theme < OnApp::Models::Base
  concerned_with *Core.concerns.fetch(:theme, [])

  SALT = '!@#$%^&*()_+'

  mount_uploader :logo,                  ThemeImageUploader
  mount_uploader :favicon,               ThemeImageUploader
  mount_uploader :body_background_image, ThemeImageUploader

  validates :label, presence: true

  scope :active, ->{ where(active: true) }

  def secure_id
    @secure_id ||= Digest::MD5.hexdigest("#{SALT}-#{id}") if persisted?
  end
end
