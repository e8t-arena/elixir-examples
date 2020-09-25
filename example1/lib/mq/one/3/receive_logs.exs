defmodule ReceiveLogs do
  def wait_for_messages(chan) do
    receive do
      {:basic_deliver, payload, _meta} ->
        IO.puts " [x] Received #{payload}"
        wait_for_messages(chan)
    end
  end
end

{:ok, conn} = AMQP.Connection.open
{:ok, chan} = AMQP.Channel.open(conn)

exchange_name = "logs"

# :fanout broadcasts all the messages it receives to all the queues it knows
AMQP.Exchange.declare(chan, exchange_name, :fanout)

#  exclusive: once the consumer connection is closed, the queue should be deleted
{:ok, %{queue: queue_name}} = AMQP.Queue.declare(chan, "", exclusive: true)

# the logs exchange will append messages to our queue
AMQP.Queue.bind(chan, queue_name, exchange_name)
AMQP.Basic.consume(chan, queue_name, nil, no_ack: true)
IO.puts " [*] Waiting for messages. To exit press CTRL+C, CTRL+C"

ReceiveLogs.wait_for_messages(chan)
