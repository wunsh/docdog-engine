# Docdog [![GitHub release](https://img.shields.io/github/release/wunsh/docdog-engine/all.svg?style=flat-square&label=docdog)](https://docdog.io) [![Build Status](https://img.shields.io/travis/wunsh/docdog-engine/master.svg?style=flat-square)](https://travis-ci.org/wunsh/docdog-engine) [![Coverage Status](https://img.shields.io/coveralls/github/wunsh/docdog-engine/master.svg?style=flat-square)](https://coveralls.io/github/wunsh/docdog-engine?branch=master) [![Licence](https://img.shields.io/github/license/wunsh/docdog-engine.svg?style=flat-square&maxAge=604800)](https://github.com/wunsh/docdog-engine/blob/master/LICENSE) [![Powered by Wunsh.ru](https://img.shields.io/badge/powered-WUNSH-yellow.svg?colorB=f3b700&style=flat-square&maxAge=2592000)](https://wunsh.ru)

Web application for co-translation of technical texts – documentations, articles, etc.

## Start your own Docdog locally

To start your Docdog server:

* Fill all environment variables from `.env.sample` to `.env` and move it to OS environment by `source .env`
* Install dependencies with `mix deps.get`
* Create and migrate your database with `mix ecto.create && mix ecto.migrate`
* Install frontend dependencies with `cd assets && yarn install`
* Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Learn more

Getting start with technologies we are using:

* Elixir – <https://elixir-lang.org/getting-started/introduction.html>
* Phoenix – <https://hexdocs.pm/phoenix>
* Elm – <http://elm-lang.org/docs>
