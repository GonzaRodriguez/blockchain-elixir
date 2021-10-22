defmodule VhsElixirWeb.WebhookController do
  @moduledoc """
  This module is used for handling all webhooks (Only Blocknative currently)
  """

  use VhsElixirWeb, :controller

  require Logger

  alias Vhs.Clients.Slack
  alias VhsElixirWeb.PendingTransaction

  @spec transaction_update(Plug.Conn.t(), request_params :: map()) :: map()
  def transaction_update(conn, %{"hash" => tx_id, "status" => _status} = params) do
    Logger.info("#{tx_id} got mined")

    PendingTransaction.remove_pending_transaction(tx_id)

    case Slack.webhook_post(params) do
      {:ok, _} ->
        conn
        |> put_status(:ok)
        |> json(%{status: "Ok"})

      {:error, _error} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "There was an error posting to slack"})
    end
  end
end
