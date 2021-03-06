defmodule AppExample.Agent.Counter do
  use Agent

  def start_link(initial_value) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  def value do
    Agent.get(__MODULE__, & &1)
  end

  def increment do
    # 竞争性操作
    Agent.update(__MODULE__, &(&1+1))
    {:ok, Agent.get(__MODULE__, & &1)}
  end
end
