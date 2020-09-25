defmodule AppExample.GenStage.Example01.Producer do
  @moduledoc """

  gen_stage Elixir School

  three roles
    :producer 等待 consumers 请求
    :producer_consumer 响应其他 consumer 请求 并请求 producer
    :consumer 从 producer 请求接收数据

  最重要的两个 init/1 handle_demand/2
  :producer 表示这是 producer

  Example:
    https://github.com/elixir-lang/gen_stage/tree/master/examples
  Data Transformation Pipeline
  Work Queue
  Event Processing

  https://blog.appsignal.com/2018/11/13/elixir-alchemy-understanding-elixirs-genstages-querying-the-blockchain.html
  数据源是 streamable 的，例如 逐行读取文件，数据库表，一系列第三方api请求
  buffer 过大或过小都影响性能。解决方法是 Backpressure
    当 buffer 满时 halt 数据接收，在系统能够处理时在回复接收数据

    GenStage 是基于 GenServer 提供简单地创建 Producer/Consumer 架构的抽象，自动管理 backpressure
    当 pipeline 准备好处理数据时，handle_demand/2 函数被调用，请求特定数量的数据。数据量是内部决定的(可以设置最大值 maximum value)，当 pipeline 中有空间时就会调用它。如果处理数据花费很多时间，Producer 会进入 idle 一会儿，从而释放系统压力。
  """
  use GenStage

  def start_link([initial] \\ [0]) do
    GenStage.start_link(__MODULE__, initial, name: __MODULE__)
  end

  def init(counter), do: {:producer, counter}

  def handle_demand(demand, state) do
    events = Enum.to_list(state..(state + demand - 1))
    {:noreply, events, state + demand}
  end
end
