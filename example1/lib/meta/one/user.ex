defmodule Meta.One.User do

  def get(id) do
    IO.puts "User #{id}"
  end

  use Meta.One.Base

end
