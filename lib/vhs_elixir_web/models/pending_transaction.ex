defmodule VhsElixirWeb.PendingTransaction do
  use Ecto.Schema

  import Ecto.Changeset

  alias __MODULE__

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
end
