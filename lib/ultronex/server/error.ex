defmodule Ultronex.Server.Error do
  @moduledoc """
  Documentation for Ultronex.Server.Error
  """
  alias Ultronex.Command.Quote, as: Quote

  def status_404 do
    json_response()
  end

  def json_response do
    %{
      msg: "You have entered an Abyss",
      quote: Quote.get_quote_to_send()
    }
  end
end
