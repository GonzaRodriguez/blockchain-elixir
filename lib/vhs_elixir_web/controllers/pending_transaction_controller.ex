defmodule VhsElixirWeb.PendingTransactionController do
  use VhsElixirWeb, :controller

  alias VhsElixirWeb.PendingTransaction

  require Logger

  @spec create(Plug.Conn.t(), request_params :: map()) :: map()
  def create(conn, %{"transaction_ids" => tx_ids}) do
    Logger.info("New transaction ids to watch: #{tx_ids}")

    status =
      case PendingTransaction.new_transaction_to_watch(tx_ids) do
        {:ok, failed_tx_ids} when failed_tx_ids != [] ->
          "Transactions with ids = '#{failed_tx_ids}' were not added to watch"

        _ ->
          "Success"
      end

    conn
    |> put_status(:created)
    |> json(%{status: status})
  end

  @spec index(Plug.Conn.t(), request_params :: map()) :: map()
  def index(conn, _) do
    Logger.info("Fetching all pending transactions")

    status = "Success"

    conn
    |> put_status(:ok)
    |> json(%{status: status})
  end
end
