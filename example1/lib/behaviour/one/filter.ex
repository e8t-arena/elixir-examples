# 支持 behaviour 和实现 分离写法
# https://hexdocs.pm/elixir/Kernel.html#defoverridable/1-example-1

defmodule Behaviour.One.Filter do
  @callback transform(String.t) :: String.t

  defmacro __using__(_params) do
    quote do
      @behaviour Behaviour.One.Filter
      # modules that use Filter must implement the callbacks defined in Filter

      def shout, do: IO.puts "HEY!"
      # def greet(s), do: IO.puts s
      def greet(s), do: transform(s)

      defoverridable [shout: 0, greet: 1]
    end
  end
end
