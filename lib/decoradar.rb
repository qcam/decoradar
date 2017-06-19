require 'set'
require 'decoradar/attribute'
require 'decoradar/collection'

# Decorates and serializes model into a hash
#
# class PlayerDecorator
#   include Decoradar
#
#   attributes :id, :name, :team
#   attribute :shirt_number
#   attribute :nationality, include_if: -> model { model.has_nationality? }
#
#   def shirt_number
#     model.team.shirt
#   end
#
#   def team
#     TeamDecorator.new(model.team)
#   end
# end
#
# PlayerDecorator.new(Player.first).as_json
module Decoradar
  def self.included(base)
    base.singleton_class.class_eval { attr_accessor :attribute_set }

    base.class_eval do
      self.attribute_set = Set.new

      extend Forwardable
      extend ClassMethods
      include InstanceMethods
    end
  end

  module ClassMethods
    def attributes(*names)
      names.map { |name| attribute(name) }
    end

    def attribute(name, options = {})
      attr = Attribute.new(options.merge(name: name))
      self.attribute_set << attr
      class_eval { def_delegators(:model, attr.name) }
    end

    def collection(name, options = {})
      col = Collection.new(options.merge(name: name))
      self.attribute_set << col
      class_eval { def_delegators(:model, col.name) }
    end

    def decorate_collection(collection)
      raise TypeError if !collection.respond_to?(:map)

      collection.map { |item| new(item) }
    end

    def inherited(child)
      child.attribute_set = attribute_set.dup

      super
    end
  end

  module InstanceMethods
    attr_reader :model

    def initialize(model)
      @model = model
    end

    def as_json(_options = nil)
      self.class.attribute_set.reduce({}) do |json, attribute|
        enrich_json(json, attribute)
      end
    end

    def enrich_json(json, attribute)
      if attribute.including?(model)
        attribute.serialize(json, value_of(attribute))
      else
        json
      end
    end

    def value_of(attribute)
      self.public_send(attribute.name.to_sym)
    end
  end
end
