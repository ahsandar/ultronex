require Logger

defmodule Ultronex.Command.Gif do
  @moduledoc """
  Documentation for Ultronex.Command.Gif
  """
  alias Ultronex.Realtime.Msg, as: Msg

  def execute(slack_message, slack_state, msg_list) do
    Logger.info("Ultronex.Command.Giphy")
    category_chosen = msg_list |> List.first() |> String.first()
    category = if is_nil(category_chosen), do: "random", else: msg_list |> List.first()
    url = random_gif_from_giphy(category)

    msg = " <@#{slack_message.user}>! I, `UltronEx` has selected a #{category} gif for you #{url}"

    Logger.info(msg)
    Msg.send(msg, slack_message.channel, slack_state)
  end

  def random_gif_from_giphy(tag) do
    url =
      "http://api.giphy.com/v1/gifs/search?api_key=#{get_giphy_api_key()}&q=#{tag}&limit=50&offset=0&rating=G&lang=en"

    response = HTTPoison.get(url)
    get_giphy_url(response)
  end

  def get_giphy_url(response) do
    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        giphy_response = Jason.decode!(body)
        giphy_response_size = Kernel.length(giphy_response["data"])

        selected_gif =
          giphy_response["data"]
          |> List.pop_at(random_selection(giphy_response_size))
          |> elem(0)

        selected_gif["url"]

      _ ->
        "Error #{response.status_code} from Giphy"
    end
  end

  def get_giphy_api_key do
    Application.fetch_env!(:ultronex, :giphy_api_key)
  end

  def random_selection(size) do
    Enum.random(1..(size - 1))
  end
end
