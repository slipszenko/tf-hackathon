# tf-hackathon

Disclaimer: I am not a ruby developer, I'm just guessing what to do. Hell, today was the first day that I wrote a Gemfile.

Instalation:

```
$ # Rename .env.example to .env and fill in the values
$ bundle install --path vendor/bundle
$ ruby myapp.rb
$ # Go look at your localhost...
```

1. Provides a foundation for building challenges or creating a new Sinatra application.
2. Demonstrates a reasonable set of practices around building Sinatra applications.
3. Eases the transition to Rails for Dev Bootcamp students

### Quickstart

1.  `bundle install`
2.  `shotgun config.ru`

As needed, create models & migrations with the `rake` tasks:

```
rake generate:migration  # Create an empty migration in db/migrate, e.g., rake generate:migration NAME=create_tasks
rake generate:model      # Create an empty model in app/models, e.g., rake generate:model NAME=User
```
