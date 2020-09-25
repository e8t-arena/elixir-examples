defprotocol Protocol.One.Notifications do
  @moduledoc """
  A protocol for dealing with the various forms of notifications.
  """
  @fallback_to_any true

  @doc "Sends a notification."
  def send(notification)
end

defimpl Protocol.One.Notifications, for: Any do
  def send(_), do: IO.puts "Default send method..."
end
