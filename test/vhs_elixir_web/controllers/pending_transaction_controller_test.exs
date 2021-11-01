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
    test "with valid data", %{conn: conn} do
      response = get(conn, Routes.pending_transaction_path(conn, :index), %{})

      assert json_response(response, 200) == %{"status" => "Success"}
    end
  end
end
