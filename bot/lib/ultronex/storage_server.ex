require Logger

defmodule Ultronex.StorageServer do
  use GenServer

  @moduledoc """
  Documentation for Ultronex.StorageServer
  """

  alias Ultronex.Realtime.TermStorage, as: TermStorage
  alias Ultronex.Utility, as: Utility

  def start_link(opts) do
    {:ok, pid} = GenServer.start_link(__MODULE__, opts)
    :timer.apply_interval(opts[:interval], __MODULE__, :perform, [pid])
    {:ok, pid}
  end

  def init(state) do
    initialize_term_storage()
    {:ok, state}
  end

  def initialize_term_storage do
    Logger.info("Creating Term Storage ...")
    TermStorage.initialize()
  end

  def perform(scheduler) do
    GenServer.cast(scheduler, :perform)
  end

  def handle_cast(:perform, opts) do
    snapshot_time = DateTime.utc_now() |> DateTime.to_string()
    IO.puts(~s{Scheduler running Snapshot for ETS #{snapshot_time}})
    Ultronex.Realtime.TermStorage.ets_tabs2file([:track, :stats, :external])
    :ets.insert(:stats, {:snapshot, snapshot_time})
    {:noreply, opts}
  end

  def terminate(reason, _state) do
    extra = reason |> elem(1)
    msg = "Storage Server terminate : #{extra}"
    Logger.error(msg)
    Utility.log_count(:external, :errors, msg)
    TermStorage.ets_tabs2file([:track, :stats, :external])
  end
end
