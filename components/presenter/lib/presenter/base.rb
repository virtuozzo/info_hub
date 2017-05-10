module Presenter
  class Base < SimpleDelegator
    delegate :t, :l, :current_user, :present, :link_to, :link_to_if, :request, to: :h

    def self.presents(name)
      define_method(name) do
        @model
      end
    end

    def initialize(model, view, form = nil)
      @model = model
      @view = view
      @form = form

      super(@model)
    end

    def h
      @view
    end

    def f
      @form
    end

    def humanized?
      @is_humanized ||= request.format.html? ? true : h.params[:humanized]
    end
  end
end
