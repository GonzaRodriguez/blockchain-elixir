defmodule VhsElixirWeb.WebhookControllerTest do
  use VhsElixirWeb.ConnCase, async: true

  alias VhsElixir.Repo
  alias VhsElixirWeb.PendingTransaction

  setup do
    %PendingTransaction{}
    |> PendingTransaction.changeset(%{tx_id: "tx_id", blockchain_type: "Etherium"})
    |> Repo.insert!()

    conn =
      build_conn()
      |> put_req_header("accept", "application/json")

    %{conn: conn}
  end

  describe "transaction_update/2" do
    test "removes the tx_id from pending transaction and sends the message", %{conn: conn} do
      tx_id = "fake_tx_id"
      params = %{"hash" => tx_id, "status" => "ok"}

      response = post(conn, Routes.webhook_path(conn, :transaction_update), params)

      refute Repo.get_by(PendingTransaction, tx_id: tx_id)
      assert json_response(response, 200) == %{"status" => "Ok"}
    end
  end
end
