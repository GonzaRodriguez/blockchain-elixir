defmodule Vhs.Clients.Slack do
  @moduledoc """
  Interface to communicate with Slack through a webhook
  """

  require Logger

  @caller Application.get_env(:vhs_elixir, :username)
  @client_config Application.get_env(:vhs_elixir, :slack)

  @spec webhook_post(map()) :: map()
  def webhook_post(%{"hash" => tx_id, "status" => status}) do
    {:ok, payload} = build_payload(tx_id, status)

    case HTTPoison.post(build_url(), payload, headers()) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}

      _ ->
        Logger.error("Received error trying to post to Slack")

        {:error, "Received error trying to post to Slack"}
    end
  end

  defp build_url, do: @client_config.base_url <> @client_config.slack_webhook

  defp headers, do: [{"content-type", "application/json"}]

  defp build_payload(tx_id, "ok"), do: build_message("*#{tx_id} got mined*", tx_id, "Ok")

  defp build_payload(tx_id, "pending"),
    do: build_message("*#{tx_id} still pending*", tx_id, "Pending")

  defp build_payload(_tx_id, _), do: "Status not supported yet"

  defp build_message(custom_text, tx_id, status) do
    %{
      text: custom_text,
      attachments: [
        %{
          blocks: [
            %{
              type: "section",
              text: %{
                type: "mrkdwn",
                text: "*From: #{@caller}*"
              }
            },
            %{
              type: "section",
              text: %{
                type: "mrkdwn",
                text: "*Status: #{status}*"
              }
            },
            %{
              type: "section",
              text: %{
                type: "mrkdwn",
                text: "*See on*"
              }
            },
            %{
              type: "section",
              text: %{
                type: "mrkdwn",
                text: "<https://etherscan.com/tx/#{tx_id}|Etherscan> :male-detective:"
              }
            }
          ]
        }
      ]
    }
    |> Jason.encode()
  end
end
