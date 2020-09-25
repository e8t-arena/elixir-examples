defmodule AppExample.Operator do
  def a > b when is_list(a), do: a ++ [b | []]
  def a > b, do: [a | [b]]
end

defmodule AppExample.OperatorTest do
  import AppExample.Operator
  import Kernel, except: [>: 2, <: 2]

  def test do
    3 > [5, 6] > 5 > [1,2,3]
  end

  def get_local_fun_name(env), do: env.function |> elem(0)

  def parse_pipeline(pipe) when is_list(pipe) do
    IO.inspect(__ENV__)
    IO.inspect(__ENV__ |> get_local_fun_name)
    pipe
    |> Enum.chunk_every(
      2, 1, :discard
    )
    |> Enum.map(fn [first, last] ->
      cond do
        is_list(first) and is_list(last) ->
          for i <- first, do:  %{i => last}
        is_list(first) ->
          for i <- first, do:  %{i => [last]}
        is_list(last) ->
          %{first => last}
      end
    end)
    # |> Enum.reduce([], fn {k, v} -> do

    # end)

  end
end

# [
#   [
#     [3,5],[5,5],[5,1]
#   ]
# ]
AppExample.OperatorTest.test()
|> AppExample.OperatorTest.parse_pipeline()
|> IO.inspect
