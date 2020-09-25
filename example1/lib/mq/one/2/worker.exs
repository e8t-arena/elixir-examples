defmodule Worker do
  def wait_for_messages(chan) do
    receive do
      {:basic_deliver, payload, meta} ->
        IO.puts " [x] Received #{payload}"

        # fake 耗时操作

        payload
        # |> to_char_list
        |> to_charlist()
        # 统计 codepoint
        |> Enum.count(fn x -> x == ?. end)
        |> Kernel.*(1000)
        |> :timer.sleep

        IO.puts " [x] Job #{payload} DONE"

        # 发送一个合适的 ack
        # Acknowledgement must be sent on the same channel that received the delivery
        AMQP.Basic.ack（chan, meta.delivery_tag)

        wait_for_messages(chan)
    end
  end
end

queue_name = "task_queue"
{:ok, conn} = AMQP.Connection.open
{:ok, chan} = AMQP.Channel.open(conn)
AMQP.Queue.declare(chan, queue_name, durable: true)

AMQP.Basic.qos(channel, prefetch_count: 1)


AMQP.Basic.consume(chan, queue_name, nil, no_ack: false)
IO.puts " [*] Waiting for messages. To exit press CTRL+C, CTRL+C"

Worker.wait_for_messages(chan)
