class DefaultInfoboxPresenter < InfoboxPresenter
  attr_accessor :exclude_default

  def render
    add_default_infobox
    super
  end

  private

  def add_default_infobox
    return if exclude_default

    action = {create: :new, update: :edit}[action_name.to_sym] || action_name
    scope  = "#{controller_path.gsub('/', '.')}.#{action}"

    title   = t('help.title',       scope: scope, app_name: OnApp.configuration.app_name)
    content = t('help.description', scope: scope, app_name: OnApp.configuration.app_name)


    item = delete(title).tap do |hash|
      hash[:content].prepend("#{content} ")
    end if has?(title)

    item ||= {content: content, skip_title: false}

    @info = Hash[title, item].deep_merge(info)
  end
end
