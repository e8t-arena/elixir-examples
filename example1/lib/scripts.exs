defmodule Scripts do
  def fun(bar, baz) do
    bar <> " and " <> baz
  end
  def fun, do: 1
end

case System.argv() do
  ["--test"] ->
    ExUnit.start()

    defmodule ScriptsTest do
      use ExUnit.Case

      import Scripts

      test "run fun" do
        assert fun() == 1
      end
    end
  [arg1, arg2] ->
    Scripts.fun(arg1, arg2) |> IO.puts
end

# elixir scripts.exs 1 2
# elixir scripts.exs --test
