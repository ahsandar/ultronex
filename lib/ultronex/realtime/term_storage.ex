defmodule Ultronex.Realtime.TermStorage do
  def initialize do
    ets_initialize()
    dets_initialize()
  end

  def ets_initialize(table \\ :track, data_type \\ :bag) do
    IO.puts("Creating :ets ...")
    :ets.new(table, [data_type, :protected, :named_table, read_concurrency: true])
  end

  def dets_initialize(table \\ :slack_count) do
    IO.puts("Creating :dets ...")
    :dets.open_file(table, type: :set, auto_save: 60000)
  end

  def dets_incr(table \\ :slack_count, key \\ :total_msg_count) do
    :dets.update_counter(table, key, {2, 1})
  end

  def dets_lookup(table \\ :slack_count, key \\ :total_msg_count) do
    :dets.lookup(table, key)[key]
  end

  def dets_close(table \\ :slack_count) do
    :dets.close(table)
  end
end
