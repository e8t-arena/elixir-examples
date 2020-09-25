defmodule AppExample.GenStage.Example02.Consumer do
  @moduledoc """
  receive lists of blocks and then process them.
  use :timer.sleep/1 模拟处理过程`
  """
  alias AppExample.GenStage.Example02.Infura
  use GenStage

  def init(_) do
    {:consumer, nil}
    # {:consumer, state, subscribe_to: [AppExample.GenStage.Example02.Producer]}
  end

  def handle_events(blocks, _from, state) do
    blocks
    |> Enum.each(fn {:ok, %{"number" => n}} ->
      IO.puts("Received block #{n}")
      :timer.sleep(1_000)
    end)
    {:noreply, [], state}
  end
end
