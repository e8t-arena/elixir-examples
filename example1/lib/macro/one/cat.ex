defmodule Macro.One.Cat do
  @fields :fields
  use Macro.One.Nice, Keyword.get(Application.get_env(:example, Cat), @fields)

  # defmacro __using__(fields) do
  #   quote do
  #     defstruct unquote(fields)
  #   end
  # end
end
