defmodule AppExample.Chat.Server do
  @moduledoc """
  ref: https://m.alphasights.com/process-registry-in-elixir-a-practical-example-4500ee7c0dcc

  Process.whereis(:chat_room)
  停止进程 |> Process.exit(:kill)
  Process.whereis(:chat_room) 新 pid

  """
  use GenServer

  def start_link(name) do
    # GenServer.start_link(__MODULE__, [])
    # 通过 name 而非 pid 访问进程
    # GenServer.start_link(__MODULE__, [], name: :chat_room)
    # via tuple
    GenServer.start_link(__MODULE__, [], name: via_tuple(name))
  end

  # API

  def add_message(pid, message) do
    GenServer.cast(pid, {:add_message, message})
  end

  def add_message(message) do
    GenServer.cast(:chat_room, {:add_message, message})
  end

  def get_messages(pid) do
    GenServer.call(pid, :get_messages)
  end

  def get_messages do
    GenServer.call(:chat_room, :get_messages)
  end

  defp via_tuple(room_name) do
    {:via, AppExample.Chat.Registry, {:chat_room, room_name}}
  end

  # SERVER

  def init(messages) do
    {:ok, messages}
  end

  def handle_cast({:add_message, new_message}, messages) do
    {:noreply, [new_message | messages]}
  end

  def handle_call(:get_messages, _from, messages) do
    {:reply, messages, messages}
  end
end
