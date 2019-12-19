defmodule Ultronex.Scheduler do
  @moduledoc """
  https://gist.github.com/danielberkompas/7212ef0ba261e4a19a0b86ec1e109282
  Schedules a Mix task to be run at a given interval in milliseconds.
  ## Options
  - `:task`: The name of the Mix task to run.
  - `:args`: A list of arguments to pass to the Mix task's `run/1` function.
  - `:interval`: The time interval in millisconds to rerun the task.
  ## Example
  In a supervisor:
      worker(MyApp.Scheduler, [[[
        task: "contest.pick_winners",
        args: [],
        interval: 60000
      ]]], id: :contest_winners)
  On its own:
      MyApp.Scheduler.start_link([task: "ping", args: [], interval: 3000])
  """

  use GenServer

  def init(init_arg) do
    {:ok, init_arg}
  end

  def start_link(opts) do
    {:ok, pid} = GenServer.start_link(__MODULE__, opts)
    :timer.apply_interval(opts[:interval], __MODULE__, :perform, [pid])
    {:ok, pid}
  end

  def perform(scheduler) do
    GenServer.cast(scheduler, :perform)
  end

  def handle_cast(:perform, opts) do
    snapshot_time = DateTime.utc_now() |> DateTime.to_string()
    Logger.info(~s{Scheduler running Snapshot for ETS #{snapshot_time}})
    Ultronex.Realtime.TermStorage.ets_tab2file(:track)
    Ultronex.Realtime.TermStorage.ets_tab2file(:stats)
    :ets.insert(:stats, {:snapshot, snapshot_time})
    {:noreply, opts}
  end
end
