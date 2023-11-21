# Messaging

A simple User <=> Institution messaging engine.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "messaging", git: "https://github.com/fondation-unit/messaging"
```

And then execute:

```bash
$ bundle
```

Copy the views and config files:

```bash
$ rails generate messaging:install
```

Set the config variables in `config/initializers/messaging.rb`.

Example :

```ruby
# frozen_string_literal: true

Messaging.configure do |config|
  config.notification_channel = "notification_channel"
  config.notification_target = "notifications-count"
  config.notification_count_method = "unread_notifications_count"
  config.user_class = "User"
  config.institution_class = "Institution"
end
```

## Assets
Compile the assets :

```bash
$ bin/rails app:assets:precompile
```

Within your main application, add the following in `app/config/manifest.js` :

```js
//= link messaging/application.js
```
