defmodule OneQueryParser do
  def parse(query) do
    query
    |> tokenize
    |> convert
  end

  def tokenize query do
    # tokenizing
    {:ok, tokens, _} =
      query
      |> String.downcase
      |> to_charlist()
      |> :query_lexer.string()
    tokens
  end

  def convert tokens do
    # parsing
    {:ok, query} =
      tokens
      |> :query_parser.parse()
    query
  end
end

# OneQueryParser.parse("select * from test")
# OneQueryParser.parse("SELECT test1.id, test2.name FROM test1, test2")
