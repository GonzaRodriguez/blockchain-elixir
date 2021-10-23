# VhsElixir

This project implements the backend challenge provided by VHS using Elixir language.

In order to make this project works you should follow the steps listed below:

## Slack

* Configure Incoming Webhooks in Slack [here](https://api.slack.com/messaging/webhooks) 
* Add the Slack webhook key in the `config/config.exs` file. Please note that the key `Slack/slack_webhook` is present there for this purpose.
* Add your username in the `config/config.exs` file. Please note that the key `username` is present there for this purpose and keep in mind it will be used as the remitent when posting messages.

## Blocknative

* Register for free API access at [Blocknative](https://docs.blocknative.com/webhook-api).
* Add the api_key in the `config/config.exs` file. Please note that the key `Blocknative/apiKey` is present there for this purpose.
* Open a tunnel in your http 4000 port to be able to receive webhooks from Blocknative
* Set the webhook url in Blocknative. Plase note that you should have an account to do it.

## API Documentation
* To generate documentation with ex_doc please run `mix docs`
* The project exposes two enpoints, one provides all pending transactions in the system and the other allow to add transactions to watch.

### POST api/pending_transactions
Add new transactions to be watched. Please note that if any of the provided ids are already in the system the request will fail. As a consequence, no transactions will be added, so you should make another request removing the problematic ids. (Don't worry in the response the endpoint will return those ids which are already in the system.)

Accepts an array of pending_transactions ids under the key `transaction_ids` in the JSON body.

Body Example:

```
{
  "transaction_ids": [
    "0x1f03f443e4e53b9e2b9af64f3cdd09fe33638fe8a2cfbeae2926220b783d0681"
  ]
}
```

### GET api/pending_transactions
Fetch all pending transaction from the system.

## Running tests
You simple have to run `mix test` and all the suite should run.

## Running in container:

Update config/dev.exs by changing the :vhs_elixir/hostname from "localhost" (running without container) to "db" (running in container).

In one terminal tab:
* `docker-compose build`
* `docker-compose up`

In a second tab, once the two commands in the first tab are completed:
* `docker-compose exec web mix ecto.setup`

If everything spins up with no errors, site will be live at localhost:4000

## To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
