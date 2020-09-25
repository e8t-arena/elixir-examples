defmodule Behaviour.One.MyFilter do
  use Behaviour.One.Filter

  def transform(s), do: s <> " (My Trans)"

  # def greet(s), do: IO.puts "Sup " <> s
end
