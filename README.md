# Docdog [![GitHub release](https://img.shields.io/github/release/wunsh/docdog-engine/all.svg?style=flat-square&label=docdog)](https://docdog.io) [![Build Status](https://img.shields.io/travis/wunsh/docdog-engine/master.svg?style=flat-square)](https://travis-ci.org/wunsh/docdog-engine) [![Coverage Status](https://img.shields.io/coveralls/github/wunsh/docdog-engine/master.svg?style=flat-square)](https://coveralls.io/github/wunsh/docdog-engine?branch=master) [![Licence](https://img.shields.io/github/license/wunsh/docdog-engine.svg?style=flat-square&maxAge=604800)](https://github.com/wunsh/docdog-engine/blob/master/LICENSE) [![Powered by Wunsh.ru](https://img.shields.io/badge/powered-WUNSH-yellow.svg?colorB=f3b700&style=flat-square&maxAge=2592000)](https://wunsh.ru)

Web application for co-translation of technical texts – documentations, articles, etc.

## Start your own Docdog locally

Now you can start your development activity very easy:

```elixir
docker-compose up
```

But make simple preparing before:

1. Install [Docker](https://docs.docker.com/install/) with [compose feature](https://docs.docker.com/compose/install/#install-compose).

1. Fill all needed environment variables from `.env.sample` to `.env`:

    ```
    cp .env.sample .env
    # Update `.env` in your favorite editor
    ```

1. Now you can `docker-compose up` it! If this is your first app booting, you need to create database and run migrations:

    ```
    # Your compose must be running
    docker-compose exec app mix do ecto.create, ecto.migrate
    ```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Learn more

Getting start with technologies we are using:

* Elixir – <https://elixir-lang.org/getting-started/introduction.html>
* Phoenix – <https://hexdocs.pm/phoenix>
* Elm – <http://elm-lang.org/docs>

## Credits

We use an awesome icon as logo and favicon created by Vladimir Belochkin. We express our gratitude to the author and the [Noun Project](https://thenounproject.com).
 
