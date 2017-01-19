# Decoradar

Decoradar is a simple decorator + serializer in Ruby

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'decoradar'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install decoradar

## Why Decoradar?

Decoradar is really **simple** (it has only 2 classes as of writing) and **magic-free** (zero monkey patch, zero auto coercion)
and aims to bring ActiveModel::Serializer/Draper DSL-style declaration to Plain Ruby Object.

## Usage

```ruby
class UserSerializer
  include Decoradar

  attributes :id, :username
  attribute :full_name, as: :name
end

UserSerializer.new(@user).as_json
# => { id: 1, username: "huynhquancam", name: "Cam Huynh" }
```

Let's say you want to tweak `full_name` a bit.

```ruby
class UserSerializer
  include Decoradar

  attributes :id, :name
  attribute :full_name, as: :name

  def full_name
    model.full_name.capitalize
  end
end

UserSerializer.new(@user).as_json
# => { id: 1, username: "huynhquancam", name: "CAM HUYNH" }
```

If we want the serialized hash to include an attribute as long as it exists, we can use `include_if` option.

```ruby
class UserSerializer
  include Decoradar

  attribute :id
  attribute :username
  attribute :is_admin, include_if: ->(model) { model.admin? }
end

UserSerializer.new(@mark).as_json
# => { id: 1, username: "zuck", is_admin: true }

UserSerializer.new(@trump).as_json
# => { id: 1, username: "realDonaldTrump" }
```

If you want to serialize a collection, there's **NO AUTO-MAGIC COERCION**, just uses `.decorate_collection`.

```ruby
UserSerializer.decorate_collection(@users).map(&:as_json)
```

## Development

1. Fork this repo.
2. Make your change and submit pull request (with specs please :smile:)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/huynhquancam/decoradar.
This project is intended to be a safe, welcoming space for collaboration, and contributors are
expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
