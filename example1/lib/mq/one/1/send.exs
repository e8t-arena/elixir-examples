{:ok, conn} = AMQP.Connection.open
{:ok, chan} = AMQP.Channel.open(conn)
AMQP.Queue.declare(chan, "hello")  # 幂等操作 idempotent
message = "Hello RabbitMQ" <> (Timex.now() |> DateTime.to_string)
AMQP.Basic.publish(chan, "", "hello", message)
# exchange ""
# routing_key "hello" 需要和 declare 参数一致 ?
# exchange is special ‒ it allows us to specify exactly to which queue the message should go
IO.puts " [x] Sent '#{message}'"
AMQP.Connection.close(conn)  # make sure the network buffers were flushed and our message was actually delivered to RabbitMQ.
