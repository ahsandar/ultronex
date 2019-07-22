defmodule Ultron.Command.Giphy do
  def gif(slack_message, slack_state, msg_list) do
    IO.puts("Ultron.Command.Giphy.gif")
    category_chosen = msg_list |> List.first() |> String.first()
    category = if is_nil(category_chosen), do: "random", else: msg_list |> List.first()
    url = random_gif_from_giphy(category)
    msg = " <@#{slack_message.user}>! I, `UltronX` have selected a #{category} gif for you #{url}"
    Ultron.Realtime.Msg.send(msg, slack_message.channel, slack_state)
  end

  def random_gif_from_giphy(tag) do
    url =
      "http://api.giphy.com/v1/gifs/search?api_key=#{get_giphy_api_key()}&q=#{tag}&limit=50&offset=0&rating=G&lang=en"

    {:ok, response} = URI.encode(url) |> Tesla.get()

    cond do
      response.status == 200 ->
        giphy_response = Poison.Parser.parse!(response.body, %{})

        selected_gif =
          List.pop_at(giphy_response["data"], random_selection(giphy_response["data"]))|>elem(0)
          

        selected_gif["url"]

      true ->
        "Error #{response.status} from Giphy"
    end
  end

  def get_giphy_api_key do
    System.get_env("GIPHY_API_KEY")
  end

  def random_selection(list) do
    Enum.random(1..(Kernel.length(list)-1)) 
  end
end
