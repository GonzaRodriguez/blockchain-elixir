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

  describe "remove_pending_transaction/1" do
    test "removes transaction by tx_id" do
      tx_id = "fake_tx_id"

      %PendingTransaction{}
      |> PendingTransaction.changeset(%{tx_id: tx_id, blockchain_type: "Etherium"})
      |> Repo.insert!()

      assert PendingTransaction.remove_pending_transaction(tx_id) == {1, nil}
    end
  end

  describe "all_pending_transactions/0" do
    test "fetchs all pending transactions" do
      tx_ids_to_watch = ["fake_tx_id", "fake_tx_id_1", "fake_tx_id_2"]

      Enum.each(tx_ids_to_watch, fn tx_id ->
        %PendingTransaction{}
        |> PendingTransaction.changeset(%{tx_id: tx_id, blockchain_type: "Etherium"})
        |> Repo.insert!()
      end)

      {:ok, tx_ids} = PendingTransaction.all_pending_transactions()

      random_tx_id = Enum.random(tx_ids_to_watch)

      assert length(tx_ids) == 3
      assert Enum.member?(tx_ids_to_watch, random_tx_id)
    end
  end
end
