defmodule AppExample.Redis do
  use GenServer

  def start_link([uri: uri]) do
    GenServer.start_link(__MODULE__, [uri: uri], [name: :appexample_redis])
  end

  @impl true
  def init([uri: uri]) do
    Redix.start_link(uri, name: :redix)
  end

  def child_spec(args) do
    # Specs for the Redix connections.

    %{
      id: __MODULE__,
      start: { __MODULE__, :start_link, [args]}
    }
  end

  @impl true
  def handle_call({:hget, key, field}, _from, conn) do
    {:ok, value} = Redix.command(conn, ["HGET", key, field])
    {:reply, value, conn}
  end

  @impl true
  def handle_call({:hget, key}, _from, conn) do
    {:ok, value} = Redix.command(conn, ["HGETALL", key])
    {:reply, value, conn}
  end

  @impl true
  def handle_call({:get, key}, _from, conn) do
    {:ok, value} = Redix.command(conn, ["GET", key])
    {:reply, value, conn}
  end

  @impl true
  def handle_call({:ping}, _from, conn) do
    {:ok, value} = Redix.command(conn, ["PING"])
    {:reply, value, conn}
  end

  @impl true
  def handle_cast({:hset, key, field, value}, conn) do
    {:ok, _} = Redix.command(conn, ["HSET", key, field, value])
    {:noreply, conn}
  end

  @impl true
  def handle_cast({:set, key, value}, conn) do
    {:ok, _} = Redix.command(conn, ["SET", key, value])
    {:noreply, conn}
  end

  def command(command) do
    Redix.command(__MODULE__, command)
  end

  # Client

  def hget(key, field, name \\ :appexample_redis) do
    GenServer.call(name, {:hget, key, field})
  end

  def hgetall(key, name \\ :appexample_redis) do
    GenServer.call(name, {:hget, key})
  end

  def get(key, name \\ :appexample_redis) do
    GenServer.call(name, {:get, key})
  end

  def hset(key, field, value, name \\ :appexample_redis) do
    GenServer.cast(name, {:hset, key, field, value})
  end

  def set(key, value, name \\ :appexample_redis) do
    GenServer.cast(name, {:set, key, value})
  end

  def ping(name \\ :appexample_redis), do: GenServer.call(name, {:ping})
end
