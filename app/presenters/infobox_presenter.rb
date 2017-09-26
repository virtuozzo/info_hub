require 'digest'

class InfoboxPresenter < ViewPresenter
  extend Forwardable

  def_delegator :info, :delete
  def_delegator :info, :has_key?, :has?

  def info
    @info ||= {}
  end

  def add(title, content, skip_title = false)
    if info.has_key?(title)
      info[title][:content] << " #{content}"
      info[title][:skip_title] = skip_title
    else
      info[title] = { content: content, skip_title: skip_title }
    end
  end

  def replace_title(title, new_title)
    info[new_title] = info.delete(title)
  end

  def replace_content(title, content)
    info[title][:content] = content if info.has_key?(title)
  end

  # Render info box
  # infobox_type can be :alert or :info
  # show_every_time if true - show always after refresh page even if the user closes infobox
  def render(infobox_type = :info, show_every_time = false)
    return '' if current_user.hidden_infobox?(identifier) && !show_every_time
    info.map do |title, params|
      wrap infobox_type  do
        title = params[:skip_title] ? ''.html_safe : title(title)
        close + title + content(params[:content])
      end
    end.join.html_safe
  end

  private

  def identifier
    Digest::MD5.hexdigest(info.to_yaml)
  end

  def wrap(infobox_type = :info, &block)
    css_class = 'infobox icon info-l'
    css_class += ' alert' if infobox_type.eql?(:alert)
    content_tag(:div, class: css_class, &block)
  end

  def close
    content_tag(:a, '', href: "/hide_infobox/#{identifier}", class: 'close_flash icon right close', 'aria-label' => 'close-info-box')
  end

  def title(title)
    content_tag(:h2, title, class: 'info-t')
  end

  def content(content)
    content_tag(:p, class: 'info-c'){ content.html_safe }
  end

end
