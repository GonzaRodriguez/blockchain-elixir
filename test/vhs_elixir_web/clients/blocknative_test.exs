defmodule VhsElixirWeb.BlocknativeTest do
  use VhsElixir.DataCase, async: true

  alias Vhs.Clients.Blocknative

  describe "watch_tx/1" do
    test "when invalid tx_id is provided" do
      invalid_tx_id = "fake_tx_id"

      {status, _reason} = Blocknative.watch_tx(invalid_tx_id)

      assert status == :error
    end

    test "when valid tx_id is provided" do
      valid_tx_id = "0x1f03f443e4e53b9e2b9af64f3cdd09fe33638fe8a2cfbeae2926220b783d0681"

      {:ok, %HTTPoison.Response{body: blocknative_response_body, status_code: status}} =
        Blocknative.watch_tx(valid_tx_id)

      {:ok, expected_msg} = %{msg: "success"} |> Jason.encode()

      assert status == 200
      assert blocknative_response_body == expected_msg
    end
  end
end
