defmodule AppExample.Bing do
  @moduledoc """
  https://cn.bing.com/search?q=cookie&ensearch=1&first=36

  Regex.named_captures ~r/data-iid="(?<iid>.*?)"/, body
  %{"iid" => "translator.5028"}

  gen_stage
    crawler :producer
    router :producer_consumer
    processor :consumer

  """
  def search(keyword) do
    keyword
  end

  def translate(words) do
    # fetch webpage
    url = "https://cn.bing.com/Translator"
    api_url = "https://cn.bing.com/ttranslatev3"
    post_body = %{
      fromLang: "en",
      text: words,
      to: "zh-Hans"
    }
    IO.puts "TEXT length: #{String.length(words)}"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{
        body: body
      }} ->
        with %{"iid" => iid} <- Regex.named_captures(~r/data-iid="(?<iid>.*?)"/, body),
          %{"IG" => ig} <- Regex.named_captures(~r/IG:"(?<IG>.*?)"/, body) do
            post(api_url, {:form, Map.to_list(post_body)}, [
              isVertical: 1,
              IG: ig,
              IID: "#{iid}.1"
            ]) |> parse_result()
          end
      {:error, reason} -> IO.inspect(reason)
      v -> v |> IO.inspect()
    end
    # request trans api
  end

  def parse_result(req) do
    case req do
      {:ok, %HTTPoison.Response{
        body: body
      }} ->
        body |> parse_result(:json)
      {:error, reason} -> reason
      v -> v
    end
  end

  def parse_result(data, :json) do
    case Jason.decode(data) do
      {:ok, data} ->
        %{
          "translations" => [%{
            "text" => data
          }]
        } = hd data
        data
    end
  end

  def post(url, body, params, headers \\ []) do
    HTTPoison.post(
      url,
      body,
      headers,
      [
        params: params
      ]
    )
  end

  def list_files(path) do
    cond do
      File.dir?(path) ->
        File.ls!(path)
        |> Enum.map(&list_files(Path.join(path, &1)))
        |> Enum.filter(&(not is_nil(&1)))
      String.ends_with?(path, ".md") -> path
      true -> nil
    end
  end

  def touch(content, path) do
    path
    |> Path.dirname
    |> Path.basename
    |> (fn last ->
      out = "./out/" <> last
      File.mkdir_p!(out)
      File.write!(Path.join(out, path |> Path.basename), content, [:write])
    end).()
  end

  def fetch() do
    # https://www.dapp.com/search
    # HTTPo
  end

  def add(x, y) when is_nil(y), do: x

  def add(x, y), do: x + y

  # def add(_x, _y), do: 10

end

# AppExample.Bing.search("github") |> IO.inspect

# list all file path
# read as stream
# read line by line, length coount > 4500 then translate
# one file done, then write

# text = "And that is the power that can be achieved by combining multiple function clauses with pattern matching. As with any powerful thing, it will be likely be abused - so only use this pattern in cases where it completely makes sense: if in doubt, multiple parameters to a function is the normal way to go."
# text
# |> List.duplicate(15)
# |> Enum.join()
# |> AppExample.Bing.translate()
# |> IO.inspect

# path = "/Users/liuxiangyu/Workplace/repos/vscode-docs/api"


# doc_path ="/Users/liuxiangyu/Workplace/repos/vscode-docs/api/get-started/your-first-extension.md"

doc_path = "/Users/liuxiangyu/Workplace/repos/Recoil/docs/docs/introduction"

# doc_path |> AppExample.Bing.list_files() |> List.flatten() |> IO.inspect

doc_path 
|> AppExample.Bing.list_files 
|> List.flatten
|> Enum.map(
  &(File.stream!(&1) 
  |> Stream.take(20) 
  |> Enum.join 
  |> AppExample.Bing.translate
  |> AppExample.Bing.touch(&1)
  )
)
# |> IO.inspect

# File.stream!("./test/test.data", [], 2048) |> Stream.run()

# File.stream!(doc_path) |> Stream.take(20) |> Enum.join() |> IO.inspect()

# File.open!(doc_path, [:read], fn file ->
#   IO.read(file, :line)
# end) |> IO.inspect

# for line <- File.open!(doc_path, [:read], fn file ->
#   IO.read(file, :line)
# end) do
#   IO.puts line
# end

# AppExample.Bing.add(3, 4) |> IO.puts()
