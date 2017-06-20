module Decoradar
  class AttributeNotFound < ::RuntimeError
    attr_reader :decorated, :attribute_name

    def initialize(decorated, attribute_name)
      @decorated = decorated
      @attribute_name = attribute_name
      super()
    end

    def message
      "Attribute ##{attribute_name} not implemented on model #{decorated.class}"
    end
  end
end
