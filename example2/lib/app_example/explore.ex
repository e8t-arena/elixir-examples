defmodule AppExample.Explore do
  def call(n1, n2, fun) do
    fun.(n1, n2)
    # AppExample.Explore.call(3, 4, &AppExample.Explore.add(&1, &2))
  end

  def add(a, b), do: a+b
end
