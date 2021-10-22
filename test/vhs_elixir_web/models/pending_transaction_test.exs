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

  describe "new_transaction_to_watch/1" do
    test "when no tx_id is provided" do
      assert PendingTransaction.new_transaction_to_watch([]) == {:error, "No tx_id provided"}
    end

    test "when an invalid tx_id is provided" do
      assert PendingTransaction.new_transaction_to_watch(["invalid_tx_id"]) ==
               {:ok, ["invalid_tx_id"]}
    end

    test "when tx_id is valid stores the new pending transaction" do
      valid_tx_id = "0x1f03f443e4e53b9e2b9af64f3cdd09fe33638fe8a2cfbeae2926220b783d0681"

      PendingTransaction.new_transaction_to_watch([valid_tx_id])

      assert Repo.get_by(PendingTransaction, tx_id: valid_tx_id)
    end
  end
end
