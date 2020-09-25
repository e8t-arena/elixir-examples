{:ok, conn} = AMQP.Connection.open
{:ok, chan} = AMQP.Channel.open(conn)
queue_name = "task_queue"
AMQP.Queue.declare(chan, queue_name)
# message = "Hello RabbitMQ" <> (Timex.now() |> DateTime.to_string)

message =
  case System.argv do
    [] -> "hello world!"
    words -> Enum.join(words, " ")
  end

AMQP.Basic.publish(chan, "", queue_name, message, persistent: true)

IO.puts " [x] Sent '#{message}'"

AMQP.Connection.close(conn)
