defmodule VhsElixirWeb.PendingTransactionControllerTest do
  use VhsElixirWeb.ConnCase, async: true

  alias VhsElixir.Repo
  alias VhsElixirWeb.PendingTransaction

  setup do
    conn =
      build_conn()
      |> put_req_header("accept", "application/json")

    %{conn: conn}
  end

  describe "create/2" do
    test "adds new tx to watch", %{conn: conn} do
      valid_tx_id = "0x1f03f443e4e53b9e2b9af64f3cdd09fe33638fe8a2cfbeae2926220b783d0681"

      response =
        post(conn, Routes.pending_transaction_path(conn, :create), transaction_ids: [valid_tx_id])

      assert Repo.get_by(PendingTransaction, tx_id: valid_tx_id)
      assert json_response(response, 201) == %{"status" => "Success"}
    end

    test "returns an error when tx can't be watched", %{conn: conn} do
      invalid_tx_id = "invalid_tx_id"

      response =
        post(conn, Routes.pending_transaction_path(conn, :create),
          transaction_ids: [invalid_tx_id]
        )

      refute Repo.get_by(PendingTransaction, tx_id: invalid_tx_id)

      assert json_response(response, 201) == %{
               "status" => "Transactions with ids = '#{invalid_tx_id}' were not added to watch"
             }
    end
  end

  describe "index/2" do
    test "returns no tx_id when the system has not pending transactions", %{conn: conn} do
      response = get(conn, Routes.pending_transaction_path(conn, :index), %{})

      assert json_response(response, 200) == %{"pending_tx_ids" => []}
    end

    test "returns the tx_ids when the system has pending transactions", %{conn: conn} do
      tx_ids_to_watch = ["fake_tx_id", "fake_tx_id_1", "fake_tx_id_2"]

      Enum.each(tx_ids_to_watch, fn tx_id ->
        %PendingTransaction{}
        |> PendingTransaction.changeset(%{tx_id: tx_id, blockchain_type: "Etherium"})
        |> Repo.insert!()
      end)

      response = get(conn, Routes.pending_transaction_path(conn, :index), %{})

      assert json_response(response, 200) == %{"pending_tx_ids" => tx_ids_to_watch}
    end
  end
end
