defmodule Example.Macro.Two.Animal do
  @after_compile __MODULE__

  def __after_compile__(_env, _bytecode) do
    # IO.inspect(env)
    # IO.inspect(bytecode)
    IO.inspect("__after_compile__")
  end

  defmacro __using__(_) do
    quote do
      def fly(_, name), do: IO.inspect("Can #{name} fly?")
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def run(_, name), do: IO.inspect("Can #{name} run?")
    end
  end
end
