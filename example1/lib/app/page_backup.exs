defmodule Example.App.PageBack do
  def backup url do
    IO.puts url
  end
end

Example.App.PageBack.backup ""
