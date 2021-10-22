defmodule VhsElixir.Repo.Migrations.AddPendingTransactionsTable do
  use Ecto.Migration

  def change do
    create table(:pending_transactions) do
      add :tx_id, :string
      add :blockchain_type, :string

      timestamps()
    end
  end
end
