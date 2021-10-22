defmodule VhsElixirWeb.PendingTransactionControllerTest do
  use VhsElixirWeb.ConnCase, async: true

  setup do
    conn =
      build_conn()
      |> put_req_header("accept", "application/json")

    %{conn: conn}
  end

  describe "create/2" do
    test "with valid data", %{conn: conn} do
      response = post(conn, Routes.pending_transaction_path(conn, :create), transaction_ids: [])

      assert json_response(response, 201) == %{"status" => "Success"}
    end
  end

  describe "index/2" do
    test "with valid data", %{conn: conn} do
      response = get(conn, Routes.pending_transaction_path(conn, :index), %{})

      assert json_response(response, 200) == %{"status" => "Success"}
    end
  end
end
