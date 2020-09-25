defmodule Example.Macro.Two.Cat do
  use Example.Macro.Two.Animal
  @before_compile Example.Macro.Two.Animal

  def fly(:cat, name), do: IO.inspect("cat #{name} can fly?")

  def run(:cat, name), do: IO.inspect("cat #{name} can run?")
end
