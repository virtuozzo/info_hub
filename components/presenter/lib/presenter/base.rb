module Presenter
  class Base < SimpleDelegator
    delegate :t, :l, :current_user, :present, :link_to, :link_to_if, :request, to: :h

    def self.presents(name)
      define_method(name) do
        @model
      end
    end

    def initialize(model, view)
      @model = model
      @view = view

      super(@model)
    end

    def h
      @view
    end

    def humanized?
      @is_humanized ||= request.format.html? ? true : h.params[:humanized]
    end
  end
end
