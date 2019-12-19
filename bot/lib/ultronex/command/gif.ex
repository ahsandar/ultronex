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

    {:ok, response} = URI.encode(url) |> Tesla.get()

    get_giphy_url(response)
  end

  def get_giphy_url(response) do
    if response.status == 200 do
      giphy_response = Jason.decode!(response.body)

      selected_gif =
        giphy_response["data"] |> List.pop_at(random_selection(giphy_response["data"])) |> elem(0)

      selected_gif["url"]
    else
      "Error #{response.status} from Giphy"
    end
  end

  def get_giphy_api_key do
    Application.fetch_env!(:ultronex, :giphy_api_key)
  end

  def random_selection(list) do
    Enum.random(1..(Kernel.length(list) - 1))
  end
end
