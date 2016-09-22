class ViewPresenter
  def initialize(template)
    @template = template
  end

  private

  def method_missing(method, *args, &block)
    @template.public_send(method, *args, &block)
  end
end