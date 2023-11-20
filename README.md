# Messaging

## Installation
Add this line to your application's Gemfile:

```ruby
gem "messaging", git: "https://github.com/fondation-unit/messaging"
```

And then execute:

```bash
$ bundle
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
