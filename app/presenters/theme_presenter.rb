class ThemePresenter < SimpleDelegator
  def render
    File.open(template_path, 'r') do |file|
      ERB.new(file.read).result(binding)
    end
  end

  def generate!
    File.open(stylesheet_path, 'w') do |file|
      file << render.gsub(/\n+/, "\n")
    end
  end

  def stylesheet_path
    Rails.root.join('public', 'themes', "#{secure_id}.css")
  end

  def stylesheet_url
    "/themes/#{secure_id}.css"
  end

  def template_path
    Core::Engine.root.join('app', 'views', 'presenters', 'theme_presenter.css.erb')
  end
end
