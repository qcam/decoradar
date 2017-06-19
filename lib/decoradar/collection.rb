module Decoradar
  class Collection < Attribute
    attr_reader :serializer

    def initialize(options = {})
      super(options)
      @serializer = options.fetch(:serializer)
    end

    def serialize(hash, collection)
      hash.merge(as => _serialize(collection))
    end

    private

    def _serialize(collection)
      collection.map do |obj|
        serializer.new(obj).as_json
      end
    end
  end
end
