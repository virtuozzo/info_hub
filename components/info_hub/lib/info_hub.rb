require 'active_support/all'

module InfoHub
  require_relative 'info_hub/hash_patch'

  extend self

  attr_accessor :default_file_path, :local_file_path

  KeyNotFoundError = Class.new(StandardError)

  def fetch(key)
    settings.fetch(key) { raise_error(key) }
  end
  alias_method :[], :fetch

  def use(key)
    yield fetch(key)
  end

  def get(*keys)
    keys.inject(settings) { |settings, key| settings.fetch(key) { raise_error(key) } }
  end

  private

  def settings
    @settings ||= default_settings.deep_merge(local_settings).deep_symbolize_keys
  end

  def default_settings
    YAML.load_file(default_file_path)
  end

  def local_settings
    return {} unless File.exists?(local_file_path)

    YAML.load_file(local_file_path)
  end

  def raise_error(key)
    raise KeyNotFoundError, "`#{key}` key not found"
  end
end
