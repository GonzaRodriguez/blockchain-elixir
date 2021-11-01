defmodule VhsElixirWeb.PendingTransaction do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  require Logger

  alias __MODULE__
  alias Vhs.Clients.Blocknative
  alias Vhs.Clients.Slack
  alias VhsElixir.Repo

  @type t :: %__MODULE__{
          tx_id: String.t(),
          blockchain_type: String.t()
        }

  schema "pending_transactions" do
    field :tx_id, :string
    field :blockchain_type, :string

    timestamps()
  end

  @spec changeset(PendingTransaction.t(), map()) :: Ecto.Changeset.t()
  def changeset(changeset, params \\ %{}) do
    changeset
    |> cast(params, [:tx_id, :blockchain_type])
    |> validate_required([:tx_id, :blockchain_type])
  end

  @doc """
  Add all new transactions to Blocknative. Also, stores the new transactions in DB to keep the system updated.

  To handle the waiting time, it spawns new process (one per new transaction)

  Returns a tuple with the :ok atom and all failed tx_ids
  """
  @spec new_transaction_to_watch([String.t()] | []) :: {:ok, [String.t()]}
  def new_transaction_to_watch([]) do
    {:error, "No tx_id provided"}
  end

  def new_transaction_to_watch(tx_ids) do
    Repo.transaction(fn ->
      failed_tx_ids =
        Enum.reduce(tx_ids, [], fn tx_id, acc ->
          case Blocknative.watch_tx(tx_id) do
            {:ok, _response} ->
              add_pending_transaction(tx_id)

              # Spawn a new process to wait 2 minutes for the blocknative response
              Process.spawn(
                fn ->
                  Process.sleep(120_000)

                  unless is_nil(Repo.get_by(PendingTransaction, tx_id: tx_id)) do
                    Slack.webhook_post(%{"hash" => tx_id, "status" => "pending"})
                  end

                  Logger.info("Process finished")
                end,
                []
              )

              acc

            {:error, _error} ->
              acc ++ [tx_id]
          end
        end)

      failed_tx_ids
    end)
  end

  @doc """
  Removes the transaction from database when the system receive an update of this transaction from Blocknative
  """
  @spec remove_pending_transaction(String.t()) :: {integer(), nil | [term()]}
  def remove_pending_transaction(tx_id) do
    # Remove pending transaction by tx_id
    from(t in PendingTransaction, where: t.tx_id == ^tx_id) |> Repo.delete_all()
  end

  @spec all_pending_transactions() :: {:ok, [Ecto.Schema.t()]} | Ecto.QueryError.t()
  def all_pending_transactions do
    # Fetch all pending transactions tx_id
    tx_ids = from(t in PendingTransaction, select: t.tx_id) |> Repo.all()

    {:ok, tx_ids}
  end

  defp add_pending_transaction(tx_id) do
    try do
      # Store the transaction in the system
      Repo.insert(changeset(%PendingTransaction{}, %{tx_id: tx_id, blockchain_type: "ETH"}))
    rescue
      Ecto.ConstraintError ->
        raise "Transaction with id = #{tx_id} already exists in the system"
    end
  end
end
