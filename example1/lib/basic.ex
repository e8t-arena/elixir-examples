defmodule Example.Basic do
  defstruct [:name, :age]

  alias __MODULE__

  def display(%Example.Basic{name: name, age: age} = basic) do
    IO.puts("#{name} - #{age}")
  end

  def fetch(keyword) do
    # url = "https://www.baidu.com/s?ie=UTF-8&wd=#{keyword}"
    url = "https://cn.bing.com/search?q=#{keyword}"

    headers = [
      {"Connection", "Keep-Alive"},
      {"Content-Type", "text/html; charset=utf-8"},
      {"Accept", "text/html, application/xhtml+xml, */*"},
      {"Accept-Language", "en-US,en;q=0.8,zh-Hans-CN;q=0.5,zh-Hans;q=0.3"},
      {"Accept-Encoding", "gzip, deflate"},
      {"User-Agent",
       "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.80 Safari/537.3"}
    ]

    responses =
      HTTPoison.get!(
        url,
        headers,
        follow_redirect: true
      )

    :zlib.gunzip(responses.body)
  end

  def convert(_data) do
    data = %{
      "api_status" => "active",
      "api_version" => "v2.2",
      "lang" => "zh_CN",
      "location" => [31.9498805, 80.2951546],
      "result" => %{
        "apparent_temperature" => -1.0,
        "aqi" => 0,
        "cloudrate" => 0.0,
        "comfort" => %{"desc" => "很冷", "index" => 8},
        "dswrf" => 1158.7,
        "humidity" => 0.07,
        "pm25" => 0,
        "precipitation" => %{
          "local" => %{
            "datasource" => "gfs",
            "intensity" => 0.0,
            "status" => "ok"
          }
        },
        "pres" => 54806.73,
        "skycon" => "WIND",
        "status" => "ok",
        "temperature" => 8.12,
        "ultraviolet" => %{
          "desc" => "极强",
          "index" => 11.0
        },
        "visibility" => 35.0,
        "wind" => %{"direction" => 309.0, "speed" => 37.44}
      },
      "server_time" => 1_560_496_419,
      "status" => "ok",
      "tzshift" => 28800,
      "unit" => "metric"
    }

    IO.inspect(data)

    fields_map = %{
      "skycon" => {"code", :convert_code},
      "temperature" => "temperature",
      "pres" => {"pressure", :convert_float},
      "humidity" => {"humidity", :convert_float},
      ["wind", "direction"] => "wind_direction_degree",
      ["wind", "speed"] => "wind_speed",
      "cloudrate" => {"clouds", :convert_float}
    }
  end

  def test_case key do
    require Logger
    case Map.get(%{a: 1}, key) do
      nil ->
        Logger.warn("no value")
        nil
      v -> IO.puts v
    end
  end

  def pp(x) do :io_lib.format("~p", [x]) |> :lists.flatten |> :erlang.list_to_binary end

  def test_interpolation do
    x = 100
    IO.puts "...#{pp(x)}"
  end

  def test_com do
    numbers = %{
      a: 1,
      b: 2,
      c: 3,
      d: 4
    }
    basic = %Basic{age: "30", name: "John"}
    [_ | keys] = Map.keys(basic)
    for k <- keys, reduce: basic do
      acc -> %{ acc | k => Map.get(basic, k) <> " +++" }
    end
  end

  def test_with do
    mydata=0
    with { :ok, data } <- add_num(mydata, 1),
         { :ok, data } <- add_num(data, 2),
         { :ok, data } <- add_num(data, 3),
         do: data
  end

  def add_num(data, num) do
    IO.puts("add_num #{data}")
    { :ok, data+num }
  end

  def test_monitor stat \\ nil do
    # monitor "~/test.txt"
    path = "~/test.txt"
    receive do
      {:exit, msg} -> msg
    after
      3_000 ->
        path |> display_file_stat(stat) |> test_monitor()
    end
  end

  def display_file_stat(path, old_stat \\ nil) do
    new_stat = path |> Path.expand |> File.stat
    if is_nil(old_stat) or new_stat == old_stat do
      "Stay the same" |> IO.puts
    else
      "Update file" |> IO.puts
    end
    new_stat
  end

  def test_task(x) when is_integer(x) do
    :timer.sleep(x)
    x * 2
    # task = Task.async(Basic, :test_task, [2000])
    # Task.await(task)
  end

  def process do
    result = %{
      "apparent_temperature" => -1.0,
      "aqi" => 0,
      "cloudrate" => 0.0,
      "comfort" => %{"desc" => "很冷", "index" => 8},
      "dswrf" => 1158.7,
      "humidity" => 0.07,
      "pm25" => 0,
      "precipitation" => %{
        "local" => %{
          "datasource" => "gfs",
          "intensity" => 0.0,
          "status" => "ok"
        }
      },
      "pres" => 54806.73,
      "skycon" => "WIND",
      "status" => "ok",
      "temperature" => 8.12,
      "ultraviolet" => %{"desc" => "极强", "index" => 11.0},
      "visibility" => 35.0,
      "wind" => %{"direction" => 309.0, "speed" => 37.44}
    }

    data_map = %{
      ["wind", "direction"] => "wind_direction_degree",
      ["wind", "speed"] => "wind_speed",
      "cloudrate" => "clouds",
      "humidity" => "humidity",
      "pres" => "pressure",
      "skycon" => "code",
      "temperature" => "temperature"
    }

    data_map |> Enum.into(%{}, fn {k, v} -> {String.to_atom(v), get_key(result, k)} end)
  end

  def get_key(data, key) when is_map(data) and is_list(key) and key != [] do
    case Map.fetch(data, hd(key)) do
      {:ok, value} when is_map(value) and is_list(key) and key != [] -> get_key(value, tl(key))
      {:ok, value} when is_map(value) and is_list(key) and key == [] -> value
      {:ok, value} -> value
      # {:ok, value} when is_map(value) and is_list(key) and key == [], {:ok, value} -> value
      :error -> nil
    end
  end

  def get_key(data, key) when is_map(data) and is_binary(key) do
    case Map.fetch(data, key) do
      {:ok, value} -> value
      :error -> nil
    end
  end

  def convert_base(number, to_base \\ 10) do
    # 0b1011 -> 9 -> 0x
    Integer.to_string number, to_base
  end
end

defmodule Example.Basic.Utils do
  # def convert_float when is_number(term)
end

# ','.join([''.join(['{"', k, '", "', headersParameters[k], '"}']) for k in headersParameters])
# ','.join([''.join(['"', k, '" => "', wn[k], '"']) for k in wn])

# iex(1)> :application.start(:iconv)
# :ok
# iex(2)> :iconv.convert("utf-8", "iso8859-15", "Hello")
# "Hello"
