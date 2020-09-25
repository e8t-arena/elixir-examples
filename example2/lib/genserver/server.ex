defmodule AppExample.Genserver.Server do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], name: :server_chat_room)
  end

  # API

  def add_message(message) do
    GenServer.cast(:server_chat_room, {:add_message, message})
  end

  def get_messages do
    GenServer.call(:server_chat_room, :get_messages, 5000)
    GenServer.call(:server_chat_room, :get_messages, 5000)
  end

  def get_messages1 do
    from_pid = GenServer.call(:server_chat_room, :get_messages, 5000)
    Process.alive?(from_pid) |> IO.inspect
    # GenServer.call(:server_chat_room, :get_messages, 5000)
  end

  # SERVER

  def init(messages) do
    {:ok, messages}
  end

  def handle_cast({:add_message, new_message}, messages) do
    {:noreply, [new_message | messages]}
  end

  def handle_call(:get_messages, from, messages) do
    {from_pid, _} =  from
    # Process.sleep(5000)
    from_pid |> IO.inspect
    Process.alive?(from_pid) |> IO.inspect
    {:reply, from_pid, messages}
  end
end
