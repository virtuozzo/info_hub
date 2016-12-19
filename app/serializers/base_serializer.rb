class BaseSerializer
  def self.serializes(name)
    define_method(name) { @target }
  end

  def self.serialize(*args)
    new(*args).serialize
  end

  def initialize(target)
    @target = target
  end

  def serialize
    raise NoMethodError
  end

  def ==(other)
    target == other.target
  end

  protected

  def target
    @target
  end
end
