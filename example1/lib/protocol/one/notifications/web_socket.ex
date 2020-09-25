defmodule Protocol.One.Notifications.WebSocket do
  defstruct [:topic, :event, :payload]
end

defimpl Protocol.One.Notifications, for: Protocol.One.Notifications.WebSocket do
  def send(n) do
    IO.puts n.topic
    IO.puts n.event
    IO.puts n.payload
  end
end
