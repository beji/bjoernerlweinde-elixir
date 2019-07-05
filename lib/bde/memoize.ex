defmodule Bde.Memoize do
  use GenServer

  require Logger

  @ets_table __MODULE__
  @default_ttl Application.get_env(:bde, __MODULE__, %{default_ttl: 0})[:default_ttl]

  def init(_) do
    Logger.info("#{__MODULE__}: default ttl is: #{@default_ttl}")
    table = :ets.new(@ets_table, [:set, :protected, :named_table])
    {:ok, table}
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def handle_call({:memoize, {module, function} = mf, args, ttl}, _from, state)
      when is_list(args) do
    key = {mf, args}
    now = :os.system_time(:seconds)
    result = apply(module, function, args)

    :ets.insert(@ets_table, {key, {result, now, ttl}})
    {:reply, result, state}
  end

  def memoize(mf, args) do
    memoize(mf, args, @default_ttl)
  end

  def memoize({module, function}, args, 0) do
    apply(module, function, args)
  end

  def memoize({module, function} = mf, args, ttl)
      when is_atom(module) and is_atom(function) and is_list(args) and is_number(ttl) do
    key = {mf, args}
    now = :os.system_time(:seconds)

    case :ets.lookup(@ets_table, key) do
      [{_, {result, created, stored_ttl}} | _] ->
        if now - stored_ttl > created do
          Logger.debug("outdated; fresh calc")
          GenServer.call(__MODULE__, {:memoize, {module, function}, args, ttl})
        else
          Logger.debug("cached entry still valid")
          result
        end

      _ ->
        Logger.debug("fresh calc")
        GenServer.call(__MODULE__, {:memoize, {module, function}, args, ttl})
    end
  end
end
