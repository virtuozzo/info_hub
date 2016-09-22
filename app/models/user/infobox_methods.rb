class User
  attr_accessible :display_infoboxes, :hidden_infoboxes
  store :infoboxes
  before_save { display_infoboxes; hidden_infoboxes; true } # initialize default value

  def display_infoboxes
    infoboxes[:display_infoboxes] = true unless infoboxes.has_key?(:display_infoboxes)
    infoboxes[:display_infoboxes]
  end
  alias_method :display_infoboxes?, :display_infoboxes

  def display_infoboxes=(value)
    infoboxes[:display_infoboxes] = Utils::AR.value_to_boolean(value)
  end

  def hidden_infoboxes
    infoboxes[:hidden_infoboxes] ||= []
  end

  def hide_infobox(infobox)
    hidden_infoboxes.push(infobox)
    update_attribute(:infoboxes, infoboxes) if persisted?
  end

  def restore_infobox(infobox)
    hidden_infoboxes.delete_if { |value| value == infobox }
    update_attribute(:infoboxes, infoboxes) if persisted?
  end

  def restore_infoboxes
    hidden_infoboxes.clear
    update_attribute(:infoboxes, infoboxes) if persisted?
  end

  def hidden_infobox?(infobox)
    hidden_infoboxes.include?(infobox) or !display_infoboxes?
  end
end