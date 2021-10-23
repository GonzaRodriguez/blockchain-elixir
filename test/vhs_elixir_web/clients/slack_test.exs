defmodule VhsElixirWeb.SlackTest do
  use VhsElixir.DataCase, async: true

  alias Vhs.Clients.Slack

  describe "webhook_post/1" do
    test "sends message when the status is ok" do
      params = %{"hash" => "fake_tx_id", "status" => "ok"}

      {:ok, status} = Slack.webhook_post(params)

      assert status == "ok"
    end

    test "sends message when the status is pending" do
      params = %{"hash" => "fake_tx_id", "status" => "pending"}

      {:ok, status} = Slack.webhook_post(params)

      assert status == "ok"
    end
  end
end
