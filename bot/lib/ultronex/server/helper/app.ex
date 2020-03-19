defmodule Ultronex.Server.Helper.App do
  @moduledoc """
  Documentation for Ultronex.Server.Helper.App
  """

  alias Ultronex.Realtime.TermStorage, as: TermStorage

  def response(response_map, msg \\ "empty response") do
    if Map.equal?(response_map, %{}) do
      %{msg: msg}
    else
      response_map
    end
  end

  def unprocessable_body do
    {422, %{msg: "Unprocessable request body"}}
  end

  def ets_to_map(table, key) do
    pattern_list = :ets.lookup(table, key)

    %{
      "#{key}":
        Enum.map(pattern_list, fn pattern ->
          term = pattern |> elem(1)
          count = pattern |> elem(2)
          {term, count}
        end)
        |> Enum.into(%{})
    }
  end

  def ets_map() do
    pattern_list = :ets.lookup(:track, "pattern")

    Enum.map(pattern_list, fn pattern ->
      term = pattern |> elem(1)
      {term, user_list(term)}
    end)
    |> Enum.into(%{})
  end

  def user_list(term) do
    u_list = :ets.lookup(:track, term)

    Enum.map(u_list, fn user_map ->
      user_map |> elem(1)
    end)
    |> Enum.join(", ")
  end

  def counters do
    %{
      uptime: TermStorage.ets_lookup(:stats, :uptime),
      total_msg_count: TermStorage.ets_lookup(:stats, :total_msg_count),
      replied_msg_count: TermStorage.ets_lookup(:stats, :replied_msg_count),
      forwarded_msg_count: TermStorage.ets_lookup(:stats, :forwarded_msg_count),
      total_attachments_downloaded: TermStorage.ets_lookup(:stats, :total_attachments_downloaded),
      total_messages_slacked: TermStorage.ets_lookup(:stats, :total_messages_slacked),
      snapshot: TermStorage.ets_lookup(:stats, :snapshot)
    }
  end

  def pretty_print_slack_msg(uuid, title, text, payload) do
    success_danger = if String.contains?(text, ":x:"), do: "danger", else: "success"

    ~s(
    <div class="card border-#{success_danger} mb-3 mr-3 ml-3">
      <div class="card-header bg-#{success_danger} text-white">
          <div class="d-flex justify-content-between">
            <div>
              <span class="font-weight-bold">#{title}</span>
            </div>
            <div>
              <span class="text-right">#{DateTime.utc_now() |> DateTime.to_string()}</span>
            </div>
           </div>
      </div>

      <div class="card-body">
       <span class="font-italic badge badge-secondary">#{uuid}</span>  
        <div  id="msg-body-#{uuid}" >
          #{slack_to_bootstrap_formatting(text)}
        </div>
        <br/>
        <div class="form-group purple-border">
          <label for="msg-payload-#{uuid}"><p class="badge badge-#{success_danger} text-uppercase">Payload</p></label>
          <textarea id="msg-payload-#{uuid}" class="form-control #{
      if success_danger == "success", do: "is-valid", else: "is-invalid"
    }" rows="5" readonly>#{payload}</textarea>
        </div>
      </div>
    </div>
  )
  end

  def slack_to_bootstrap_formatting(text) do
    text
    |> String.replace(":heavy_check_mark:", ~s(<span class="badge badge-success">Valid</span>))
    |> String.replace(":x:", ~s(<span class="badge badge-danger">Invalid</span>))
    |> String.replace("_*", "<i><b>")
    |> String.replace("* ", "</b> ")
    |> String.replace("_", "</i><br/>")
    |> String.replace(" *", "<b>")
    |> String.replace("*", "</b><br/>")
  end
end
