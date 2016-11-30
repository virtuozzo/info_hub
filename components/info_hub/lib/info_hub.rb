require 'active_support/all'
require 'yaml'

module InfoHub
  extend self

  attr_accessor :info_hub_file_paths

  KeyNotFoundError = Class.new(StandardError)
  SettingsNotFinalizedError = Class.new(StandardError)
  SettingsAlreadyFinalizedError = Class.new(StandardError)

  def info_hub_file_paths
    @info_hub_file_paths ||= []
  end

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

  def finalize!
    raise SettingsAlreadyFinalizedError, 'InfoHub configuration is already finalized.' if finalized?

    info_hub_file_paths.freeze
  end

  def finalized?
    info_hub_file_paths.frozen?
  end

  private

  def settings
    @settings ||= begin
      raise SettingsNotFinalizedError, 'Settings not finalized' unless finalized?

      info_hub_file_paths.inject({}) do |settings, path|
        settings.deep_merge!(YAML.load_file(path).deep_symbolize_keys)
      end
    end
  end

  def raise_error(key)
    raise KeyNotFoundError, "`#{key}` key not found"
  end
end
