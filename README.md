# Spina::Pro

Spina Pro is a Rails engine that adds a collection of extra features to a
[Spina CMS](https://www.spinacms.com) project. It was previously distributed as
a commercial add-on and is now open source under the MIT license.

## Features

- **Global search** — full-text search across pages and other models, powered by
  `pg_search`.
- **Page revisions & drafts** — keep a version history of pages and work on
  multiple drafts before publishing.
- **Messages & inboxes** — store and manage form submissions (e.g. contact
  forms) in the admin, with forwarding, archiving and spam/ham handling.
- **Rewrite rules** — manage redirects, including auto-generated suggestions.
- **404 tracking** — track and review not-found errors so you can fix broken
  links.
- **Date & DateTime parts** — extra page parts (`Spina::Parts::Pro::Date` and
  `Spina::Parts::Pro::DateTime`) and ordering pages by date.
- **UI niceties** — recently visited pages, hints, and an enhanced SEO tab.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "spina-pro"
```

And then execute:

```bash
$ bundle install
```

Run the migrations from the engine:

```bash
$ bin/rails spina_pro:install:migrations
$ bin/rails db:migrate
```

## Configuration

Spina Pro can be configured in an initializer:

```ruby
# config/initializers/spina_pro.rb
Spina::Pro.disable_hints          = false
Spina::Pro.hide_inboxes           = false
Spina::Pro.postgresql_dictionary  = "english"
Spina::Pro.track_not_found_errors = true
```

Spina Pro requires Spina `>= 2.15.0` and a PostgreSQL database (the search and
several other features rely on PostgreSQL-specific functionality).

## Contributing

Bug reports and pull requests are welcome. This project is released under the
MIT license, so feel free to use it, fork it and build on top of it.

## License

The gem is available as open source under the terms of the
[MIT License](LICENSE).
