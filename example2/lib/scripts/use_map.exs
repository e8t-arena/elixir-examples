defmodule AppExample.Scripts.Auto do
  # defmacro gen_var(map) do
  #   Enum.map map, fn {k, v} ->
  #     var = Macro.var(k, nil)
  #     quote do
  #       unquote(var) = unquote(v)
  #     end
  #   end
  # end
  defmacro initialize_to_char_count(variables) do
    {_, _, quoted_map} = variables
    Enum.map quoted_map |> Map.new, fn({name, value}) ->
      var = Macro.var(name |> String.to_atom, nil)
      # length = name |> Atom.to_string |> String.length
      quote do
        unquote(var) = unquote(value)
      end
    end
  end
end

defmodule AppExample.Scripts.UseMap do
  require AppExample.Scripts.Auto

  def run do
    # AppExample.Scripts.Auto.gen_var %{"aaa" => "aaa1", "bbb" => "bbb1"}
    # IO.inspect()
    # [red, green, yellow]

    AppExample.Scripts.Auto.initialize_to_char_count %{"aaa" => "aaa1", "bbb" => "bbb1"}

    [aaa, bbb] |> IO.inspect
  end
end

AppExample.Scripts.UseMap.run()
