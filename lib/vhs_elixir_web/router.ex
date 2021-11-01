defmodule VhsElixirWeb.Router do
  use VhsElixirWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", VhsElixirWeb do
    pipe_through :api

    resources "/pending_transactions", PendingTransactionController, only: [:index, :create]
  end

  post "/blocknative/confirm", VhsElixirWeb.WebhookController, :transaction_update
end
