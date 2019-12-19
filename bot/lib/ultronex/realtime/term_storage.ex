require Logger

defmodule Ultronex.Realtime.TermStorage do
  @moduledoc """
  Documentation for Ultronex.RealtimeTermStorage
  """
  def initialize do
    ets_initialize()
    initialize_stats()
  end

  def initialize_stats do
    output = ets_initialize(:stats, :set)

    case output do
      {:error, _} ->
        Ultronex.BotX.ets_initialize()

      _ ->
        Logger.debug(":ets : stats loaded from file")
    end
  end

  def ets_initialize(table \\ :track, data_type \\ :bag) do
    Logger.info("Creating :ets : #{table} , type : #{data_type}")

    output = :ets.file2tab('tab/#{table}.tab')

    case output do
      {:error, _} ->
        Logger.info(":ets : #{table} created from fresh")

        :ets.new(table, [
          data_type,
          :public,
          :named_table,
          read_concurrency: true,
          write_concurrency: true
        ])

      {:ok, _} ->
        Logger.info(":ets : #{table} created from file")

      _ ->
        Logger.debug(":ets : #{table} - WTF !!!!!!")
    end

    output
  end

  def ets_incr(table \\ :stats, key \\ :total_msg_count) do
    :ets.update_counter(table, key, 1, {2, 1})
  end

  def ets_lookup(table \\ :stats, key \\ :total_msg_count) do
    :ets.lookup(table, key)[key]
  end

  def ets_tab2file(table) do
    Logger.info("Saving.... :ets : #{table} to file")
    :ets.tab2file(table, 'tab/#{table}.tab')
  end
end
