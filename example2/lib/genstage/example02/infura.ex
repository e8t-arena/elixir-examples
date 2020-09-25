defmodule AppExample.GenStage.Example02.Infura do
  @moduledoc """
  consider reading chunks of data from an external data source

  以 Ethereum blockchain 为例，使用 https://github.com/teamon/tesla

  """
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://ropsten.infura.io/")

  plug(Tesla.Middleware.JSON, decode_content_types: ["text/plain; charset=utf-8"])

  def get_block(number) do
    # eth_getBlockByNumber rpc 方法名
    case call(:eth_getBlockByNumber, [to_hex(number), true]) do
      {:ok, nil} -> {:error, :block_not_found}
      error -> error
    end
  end

  def call(method, params \\ []) do
    case post("", %{jsonrpc: "2.0", id: "call_id", method: method, params: params}) do
      {:ok, %Tesla.Env{status: 200, body: %{"result" => result}}} ->
        {:ok, result}
      {:error, _} = error -> error
    end
  end

  def to_hex(decimal), do: "0x" <> Integer.to_string(decimal, 16)
end
