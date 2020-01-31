defmodule Ultronex.Server.Controller.Error do
  @moduledoc """
  Documentation for Ultronex.Server.Controller.Error
  """
  use Appsignal.Instrumentation.Decorators

  alias Ultronex.Command.Quote, as: Quote

  @decorate transaction_event()
  def status_404 do
    error_response()
  end

  def error_response do
    %{
      msg: "You have entered an Abyss",
      quote: Quote.get_quote_to_send()
    }
  end
end
