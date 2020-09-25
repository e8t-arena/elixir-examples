defmodule Macro.One.Nice do
  defmacro nice_print({:+, _meta, [lhs, rhs]}) do
    quote do
      IO.puts """
        #{unquote(lhs)}
      + #{unquote(rhs)}
        --
        #{unquote(lhs+rhs)}
      """
    end
  end

  defmacro __using__(fields) do
    quote do
      defstruct unquote(fields)
    end
  end
end
