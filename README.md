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

Spina Pro requires Spina `>= 2.21` and a PostgreSQL database (the search and
several other features rely on PostgreSQL-specific functionality). The admin
views use Tailwind CSS 4 classes, which Spina 2.21 compiles; use Spina Pro
0.13 with older Spina versions.

## Forwarding messages

When an inbox has a forward email, new messages are emailed to it. A message
class can change where and how a message is forwarded:

```ruby
class ContactForm < Spina::Pro::Message
  field :name, :string, index: true
  field :email, :string
  field :message, :text

  # Recipient (default: the inbox's forward email)
  def forward_target
    "sales@example.com"
  end

  # Subject (default: the spina.pro.message_mailer.forward.subject translation)
  def forward_subject
    "New contact form message from #{name}"
  end

  # Extra mail headers
  def forward_email_headers
    {reply_to: email}
  end
end
```

If the app has a template named after the message class, such as
`app/views/spina/pro/message_mailer/contact_form.html.erb`, it is used instead
of the default forward template. `Spina::Pro::MessageMailer.forward(message,
to: "someone@example.com")` sends a message to any address.

## Contributing

Bug reports and pull requests are welcome. This project is released under the
MIT license, so feel free to use it, fork it and build on top of it.

### Running the tests

The tests run against the dummy app in `spec/dummy` and need PostgreSQL. Point
`DATABASE_URL` at a test database when your local user can't connect as-is:

```bash
export DATABASE_URL=postgres://postgres:postgres@localhost:5432/spina_pro_test
(cd spec/dummy && RAILS_ENV=test bin/rails db:create db:schema:load)
bundle exec rake test
```

## License

The gem is available as open source under the terms of the
[MIT License](LICENSE).
