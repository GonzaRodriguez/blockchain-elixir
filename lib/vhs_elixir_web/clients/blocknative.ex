defmodule Vhs.Clients.Blocknative do
  @moduledoc """
  Interface to communicate with Blocknative's API
  """

  require Logger

  @client_config Application.get_env(:vhs_elixir, :blocknative)

  @spec watch_tx(String.t()) :: map()
  def watch_tx(tx_id) do
    case HTTPoison.post(build_url(), build_payload(tx_id), headers()) do
      {:ok, %HTTPoison.Response{status_code: 200} = response} ->
        {:ok, response}

      {:ok, %HTTPoison.Response{status_code: 400, body: reason}} ->
        Logger.error(
          "Received error trying to watch #{inspect(tx_id)} with reason #{inspect(reason)}"
        )

        {:error, "Error when posting to Blocknative. Reason = #{reason}"}
    end
  end

  defp build_payload(tx_id) do
    {:ok, payload} =
      @client_config.payload
      |> Map.merge(%{hash: tx_id})
      |> Jason.encode()

    payload
  end

  defp build_url, do: @client_config.base_url <> @client_config.transaction_path

  defp headers, do: [{"content-type", "application/json"}]
end
