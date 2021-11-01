defmodule VhsElixirWeb.PendingTransactionTest do
  use VhsElixir.DataCase, async: true

  alias VhsElixirWeb.PendingTransaction

  test "pending transaction with valid attributes" do
    tx =
      PendingTransaction.changeset(%PendingTransaction{}, %{
        tx_id: "fake_tx_id",
        blockchain_type: "Etherium"
      })

    assert tx.valid?
  end
end
