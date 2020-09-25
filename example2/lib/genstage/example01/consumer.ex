defmodule AppExample.GenStage.Example01.Consumer do
  use GenStage

  def start_link(_) do
    # GenStage.start_link(__MODULE__, :state_doesnt_matter, name: __MODULE__)
    GenStage.start_link(__MODULE__, :state_doesnt_matter)
  end

  def init(state) do
    {:consumer, state, subscribe_to: [AppExample.GenStage.Example01.ProducerConsumer]}
  end

  def handle_events(events, _from, state) do
    for event <- events do
      IO.inspect({self(), event, state})
    end
    {:noreply, [], state}
  end
end
