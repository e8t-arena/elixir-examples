defmodule Engine.Utils do
    def init_data do
    [
      %{"id" => ID1, "policy" => [expr: "1 + 100"]},
      %{"id" => ID2, "policy" => [expr: "1 + 200"]},
      %{"id" => ID3, "policy" => [expr: "1 + 300"]},
      %{"id" => ID4, "policy" => [expr_error: "1 + 400"]}
    ]
  end

  def parse_policy policy do
    Keyword.fetch(policy, :expr)
  end
end

defmodule Engine.Test do
  @each 10

  alias Engine.Utils
  require Logger

  Utils.init_data
  |> Enum.map(fn %{"id"=>id, "policy"=>policy} ->
    def parse(unquote(id)) do
      unquote(@each + 10)
    end
  end)

  def load [a, b]=arg do
    Logger.info(a)
    Logger.info(b)
  end

  def sigil_i(string, []), do: String.to_integer(string)

  def sigil_l(string, []) do
    string
    |> String.replace(" ", "")
    |> String.split(",")
    # [aaa, bbb] = [1,2]
    # ~l(aaa, bbb)
  end

  def read_csv do
    path = "/Users/liuxiangyu/Seniverse/v4_crawler/v0.0.3/accio_crawler/_build/test/lib/accio_crawler/priv/cache/weathercn/city_mapping.csv"
    File.stream!(path <> ".1")
    |> Stream.filter(&(!String.starts_with?(&1, "name")))
    # String.trim(&1)
    |> Stream.map(fn line ->
      line_to_list = line
      |> String.trim
      |> String.split(",")
      [_, key, value, _] = line_to_list
      {key, value}
    end)
    |> Enum.to_list
    |> Enum.into(%{})

  end

  defguard is_even(value) when is_integer(value) and rem(value, 2) == 0
  defguard is_all_list(v1, v2) when is_list(v1) and is_list(v2)
  # defmacro is_all_list(values) do
  #   quote do
  #     is_integer(unquote(number)) and rem(unquote(number), 2) == 0
  #     Enum.all?(unquote(values), fn v -> is_list(v) end)
  #   end
  # end

  def test([v1, v2]=values) when is_all_list(v1, v2) do
    # bin = :crypto.hash(:md5, "client20190613,tqt,")
    # for << c <- bin>>, into: "", do: List.to_string(:io_lib.format("~2.16.0b", [c]))
    # "client20190613,tqt,"
    # |> (&:crypto.hash(:md5, &1)).()
    # |> (&(for <<  c <- &1>>, into: "", do: List.to_string(:io_lib.format("~2.16.0b", [c])))).()

    # values |> inspect |> IO.puts

    msg = ~s({'61789': {'pp': '22001|22001|33001|33001|33003|33003|33003', 'be': '40004041|40003042|40003042|40003042|40003042|40000042|40000042'}})
    msg = Jason.decode! msg
  end
end

defmodule Engine.Module do
  # IO.puts "What?"
  require Logger

  alias Engine.Utils

  Utils.init_data
  |> Enum.map(fn %{"id"=>id, "policy"=>policy} ->
    case Utils.parse_policy(policy) do
      {:ok, expr} ->
        Logger.info("expr id: #{id}")
        def parse(unquote(id)) do
          unquote(expr)
        end
      :error ->
        Logger.warn("Failed: #{id}")
    end
  end)

  def parse(_) do
    Logger.warn("Match empty parser")
    false
  end
end


defmodule Fun.Game do
  @enforce_keys [:status]

  alias __MODULE__
  defstruct(
    time: nil,
    status: :init
  )

  def new(status) do
    %Game{status: status}
  end
end
