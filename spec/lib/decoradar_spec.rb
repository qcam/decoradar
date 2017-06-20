require 'spec_helper'

describe Decoradar, type: :lib do
  describe '#as_json' do
    let(:decorator_klass) do
      Class.new do
        include Decoradar

        attributes :id, :name
        attributes :greet

        def greet
          "Hello, #{model.name}"
        end
      end
    end

    it 'hashifies the model' do
      model = Struct.new(:id, :name).new(1, 'Foo')
      decorator = decorator_klass.new(model)

      expected_return = { id: 1, name: 'Foo', greet: 'Hello, Foo' }

      expect(decorator.as_json).to eq(expected_return)
    end

    context 'serialized method has not been implemented' do
      it 'raises error' do
        model = Struct.new(:id).new(1)
        decorator = decorator_klass.new(model)

        expect { decorator.as_json }.to raise_error(Decoradar::AttributeNotFound, /Attribute #name not implemented on model/)
      end
    end

    context ':if clause exists' do
      let(:decorator_klass) do
        Class.new do
          include Decoradar

          attributes :id, :name
          attribute :greet, include_if: lambda { |model| model.name == 'Alice' }

          def greet
            "Hello, #{model.name}"
          end
        end
      end

      it 'checks if we should include the field' do
        model = Struct.new(:id, :name).new(1, 'Alice')
        decorator = decorator_klass.new(model)

        expected_return = { id: 1, name: 'Alice', greet: 'Hello, Alice' }

        expect(decorator.as_json).to eq(expected_return)

        model = Struct.new(:id, :name).new(2, 'Bob')
        decorator = decorator_klass.new(model)

        expected_return = { id: 2, name: 'Bob' }

        expect(decorator.as_json).to eq(expected_return)
      end
    end
  end

  describe '.decorate_collection' do
    let(:decorator_klass) { Class.new { include Decoradar } }

    context 'param is a valid collection' do
      it 'decorates and map every object as a collection' do
        items = [1, 2]

        decorators = decorator_klass.decorate_collection(items)

        expect(decorators).to be_an(Array)
        expect(decorators.first.model).to eq(1)
        expect(decorators.last.model).to eq(2)
      end
    end

    context 'param is not a valid collection' do
      it 'raise error' do
        expect { decorator_klass.decorate_collection(1) }.to raise_error(TypeError)
      end
    end
  end

  describe 'inheritance' do
    let(:parent_klass) do
      Class.new do
        include Decoradar

        attributes :id, :name

        def name
          model.name.upcase
        end
      end
    end

    let(:child_klass) do
      Class.new(parent_klass) do
        attribute :say_my_name

        def say_my_name
          "My name is #{name}"
        end
      end
    end

    it 'inherits attributes from its parent' do
      model = Struct.new(:id, :name).new(1, 'foo')
      decorator = child_klass.new(model)

      expected_return = { id: 1, name: 'FOO', say_my_name: 'My name is FOO' }

      expect(decorator.as_json).to eq(expected_return)
    end
  end

  describe 'collections' do
    let(:decorator_klass) do
      post_serializer = Class.new do
        include Decoradar

        attribute :name
      end

      Class.new do
        include Decoradar

        attributes :id, :name
        collection :posts, serializer: post_serializer, as: :articles
      end
    end

    it 'serializes collection' do
      model = Struct.new(:id, :name, :posts).new(1, 'foo', [double("Post", name: 'what-a-post')])
      decorator = decorator_klass.new(model)

      expected_return = { id: 1, name: 'foo', articles: [{name: 'what-a-post'}] }

      expect(decorator.as_json).to eq(expected_return)
    end
  end
end
