defmodule Ultronex.Server.Error do
  @moduledoc """
  Documentation for Ultronex.Server.Error
  """
  def status_404 do
    html_404()
  end

  def html_404 do
    ~s"""
        <HTML>
    <HEAD> <TITLE>You have entered an abyss</TITLE> </HEAD>
    <BODY>
      <IMG SRC=\"https://media.comicbook.com/uploads1/2014/10/ultron-annihilation-110473.png\">
    </BODY>
    </HTML>
    """
  end
end
