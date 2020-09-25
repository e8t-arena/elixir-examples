defmodule BEAM.Sample do
  def addition do
    2 + 3
  end

  def an_atom do
    :hello
  end

  def a_call do
    value = addition() + 1
    value + 4
  end
end

# elixirc sample.ex
# file Elixir.BEAM.Sample.beam

# reading the .beam file
# :beam_lib.chunks('Elixir.BEAM.Sample.beam', [:abstract_code])
# :beam_lib.chunks('lib/beam/Elixir.BEAM.Sample.beam', [:abstract_code])
# {:ok, {module, [abstract_code: {:raw_abstract_v1, attributes}]}} =
#   :beam_lib.chunks('Elixir.MyModule.beam', [:abstract_code])

# attributes
# |> Enum.filter(&(elem(&1, 0) == :function))
# |> Enum.map(fn {_, _, name, arity, _} -> {name, arity} end)
