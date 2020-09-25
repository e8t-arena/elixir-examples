defmodule Example.Stack do
  use GenServer

  # Client

  def start_link(default) when is_list(default) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  def set(key, value) do
    GenServer.cast(__MODULE__, {:set, key, value})
  end

  # Server (callbacks)

  @impl true
  def init(_opts) do
    # {:ok, stack}
    Redix.start_link("redis://localhost:6379/3", name: :redix)
  end

  @impl true
  def handle_call({:get, key}, _from, conn) do
    {:ok, value} = Redix.command(conn, ["GET", key])
    {:reply, value}
  end

  @impl true
  def handle_cast({:set, key, value}, conn) do
    {:ok, _} = Redix.command(conn, ["SET", key, value])
    {:noreply, conn}
  end


  # @impl true
  # def handle_call(:pop, _from, [head | tail]) do
  #   {:reply, head, tail}
  # end

  # @impl true
  # def handle_cast({:push, element}, state) do
  #   {:noreply, [element | state]}
  # end
end
