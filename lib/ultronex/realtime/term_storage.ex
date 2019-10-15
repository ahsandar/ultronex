require Logger

defmodule Ultronex.Realtime.TermStorage do
  def initialize do
    ets_initialize()
    ets_initialize(:slack_count, :set)
  end

  def ets_initialize(table \\ :track, data_type \\ :bag) do
    Logger.info("Creating :ets : #{table} , type : #{data_type}")

    :ets.new(table, [
      data_type,
      :protected,
      :named_table,
      read_concurrency: true,
      write_concurrency: true
    ])
  end

  def ets_incr(table \\ :slack_count, key \\ :total_msg_count) do
    :ets.update_counter(table, key, 1, {2, 1})
  end

  def ets_lookup(table \\ :slack_count, key \\ :total_msg_count) do
    :ets.lookup(table, key)[key]
  end
end
