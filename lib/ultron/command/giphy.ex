defmodule Ultron.Command.Giphy do
  def gif(slack_message, slack_state, msg_list) do
    IO.puts("Ultron.Command.Giphy.gif")
    url = random_gif_from_giphy("random")
    msg = " <@#{slack_message.user}>! I, `UltronX` have selected a random gif for you #{url}"
    Ultron.Realtime.Msg.send(msg, slack_message.channel, slack_state)
  end

  def random_gif_from_giphy(tag) do
    url =
      "http://api.giphy.com/v1/gifs/search?api_key=#{get_giphy_api_key()}&q=#{tag}&limit=1&offset=0&rating=G&lang=en"

    {:ok, response} = Tesla.get(url)

    giphy_response = Poison.Parser.parse!(response.body, %{})
    List.first(giphy_response["data"])["url"]
  end

  def get_giphy_api_key do
    System.get_env("GIPHY_API_KEY")
  end
end
