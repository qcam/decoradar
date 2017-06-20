# Decoradar

[![Travis](https://img.shields.io/travis/qcam/decoradar.svg)](https://travis-ci.org/qcam/decoradar)
[![RubyGems](https://img.shields.io/gem/v/decoradar.svg)](https://rubygems.org/gems/decoradar)

As the name might have implied, Decoradar is a simple JSON serializer + decorator in Ruby.

## Installation

Add this line to your application's Gemfile:

    gem 'decoradar', '~> 0.1.0'

And then execute:

    $ bundle

## Why Decoradar?

Decoradar is really **simple** and **magic-free** (zero monkey patch, zero auto coercion)
and aims to bring ActiveModel::Serializer to Plain Ruby Object.

What will Decoradar brings you?

- `ActiveModel::Serializer` DSL style.
- Magic free and explicit: there is no monkey patching or auto coercion.
- Isolated testing: it's just Ruby objects without Rails dependence so feel free to unit
  test it. (when I said unit-test I meant it)

## Usage

```ruby
class UserSerializer
  include Decoradar

  attributes :id, :username
  attribute :full_name, as: :name

  collection :posts, serializer: PostSerializer
end

UserSerializer.new(@user).as_json
# => { id: 1, username: "huynhquancam", name: "Cam Huynh", posts: [{...}] }
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

Bug reports and pull requests are welcome on GitHub at https://github.com/qcam/decoradar.
This project is intended to be a safe, welcoming space for collaboration, and contributors are
expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
