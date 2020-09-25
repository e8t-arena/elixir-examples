{:ok, conn} = AMQP.Connection.open
{:ok, chan} = AMQP.Channel.open(conn)
exchange_name = "logs"

message =
  case System.argv do
    [] -> "Hello World!"
    words -> Enum.join(words, " ")
  end

AMQP.Exchange.declare(chan, exchange_name, :fanout)

AMQP.Basic.publish(chan, exchange_name, "", message)

IO.puts " [x] Sent '#{message}'"

AMQP.Connection.close(conn)
