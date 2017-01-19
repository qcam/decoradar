require 'spec_helper'

describe Decoradar::Attribute, type: :lib do
  describe '#initialize' do
    it 'initializes an attribute by a hash option' do
      attribute = Decoradar::Attribute.new(name: :foo, as: :bar)

      expect(attribute.name).to eq :foo
      expect(attribute.as).to eq :bar
      expect(attribute.include_if).to be_nil
    end

    context 'no :as options passed' do
      it 'takes :name' do
        attribute = Decoradar::Attribute.new(name: :foo)

        expect(attribute.name).to eq :foo
        expect(attribute.as).to eq :foo
      end
    end

    context ':if passed in' do
      it 'includes ' do
        func = -> {}
        attribute = Decoradar::Attribute.new(name: :foo, include_if: func)

        expect(attribute.name).to eq :foo
        expect(attribute.as).to eq :foo
        expect(attribute.include_if).to eq func
      end
    end
  end

  describe '#serialize' do
    it 'serializes the value' do
      hash = {}
      attribute = Decoradar::Attribute.new(name: :name, as: :bar)
      expect(attribute.serialize(hash, 'hello')).to eq(bar: 'hello')
    end
  end

  describe '#including?' do
    context ':if clause has not been passed in' do
      it 'always including' do
        attribute = Decoradar::Attribute.new(name: :name, as: :bar)

        expect(attribute.including?(1)).to be_truthy
      end
    end

    context 'if clause passed in and returns true' do
      it 'includes' do
        object = double('model')
        func = proc { |model| model.foo?  }
        attribute = Decoradar::Attribute.new(name: :name, as: :bar, include_if: func)
        expect(object).to receive(:foo?).once.and_return(true)
        expect(attribute.including?(object)).to be_truthy
      end
    end

    context 'if caluse passed in and returns false' do
      it 'does not include' do
        object = double('model')
        func = proc { |model| model.foo?  }
        attribute = Decoradar::Attribute.new(name: :name, as: :bar, include_if: func)
        expect(object).to receive(:foo?).once.and_return(false)
        expect(attribute.including?(object)).to be_falsey
      end
    end
  end
end
