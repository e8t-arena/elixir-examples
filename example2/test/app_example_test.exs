defmodule AppExampleTest do
  use ExUnit.Case
  doctest AppExample

  test "greets the world" do
    assert AppExample.hello() == :world
  end
end
