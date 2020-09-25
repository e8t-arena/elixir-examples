defmodule AppExample.StreamWrite do
  def stream_file(input, output) do
    input
    |> Stream.take(10)
    |> Stream.into(output)
  end

  def primer_stream do
    Stream.cycle([[name: "John", age: "42", id: "4774", plan: "premium"]])
    |> Stream.take(1000_000)
    |> Stream.map(fn record ->
      [Enum.join(Keyword.values(record), ","), "\n"]
      end)
    |> Stream.into(File.stream!("records.csv"))
    |> Stream.run
  end
end

path = "/Users/liuxiangyu/Seniverse/v4_crawler/v0.0.3/accio_crawler/_build/dev/lib/accio_crawler/priv/cache/drizzle/cities_V20160803-215718"

input = File.stream!(path)

output = File.stream!(path <> "_output")
# output = File.stream!(path <> "_output", [:write, :utf8])

# AppExample.StreamWrite.stream_file(input, output) |> Stream.run

AppExample.StreamWrite.primer_stream()
