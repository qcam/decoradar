module Decoradar
  class Attribute
    attr_reader :name, :as, :include_if

    def initialize(options = {})
      @name = options.fetch(:name)
      @as = options.fetch(:as, @name)
      @include_if = options[:include_if]
    end

    def including?(object)
      case include_if
      when nil then true
      when Proc then include_if.call(object)
      else false
      end
    end

    def serialize(hash, value)
      hash.merge(as => value)
    end
  end
end
