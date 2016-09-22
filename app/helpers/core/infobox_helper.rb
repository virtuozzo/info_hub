module Core::InfoboxHelper
  def infobox(options = {})
    title   = options[:title]       || t('.help.title')
    content = options[:description] || t('.help.description')
    type    = options[:type] || :info # or alert
    show_every_time = options[:show_every_time] || false
    infobox = InfoboxPresenter.new(self)
    infobox.add(title, content, options[:skip_title])
    infobox.render(type, show_every_time)
  end

  def default_infobox_presenter
    @default_infobox_presenter ||= DefaultInfoboxPresenter.new(self)
  end

  def add_default_infobox(options = {})
    title   = options[:title]       || t('.help.title')
    content = options[:description] || t('.help.description')
    default_infobox_presenter.add(title, content, options[:skip_title])
  end
end