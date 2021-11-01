defmodule VhsElixir.Repo.Migrations.AddTxIdIndexToPendingTransactionsTable do
  use Ecto.Migration

  def change do
    create(unique_index(:pending_transactions, [:tx_id], name: "unique_tx_id"))
  end
end
