defmodule AppExample.TinyUrl do
  @moduledoc """
  https://tinyurl.com/create.php?source=indexpage&url=https%3A%2F%2Felixirforum.com%2Ft%2Fhow-to-inject-macro-functions-at-end-of-module%2F19434&alias=
  """

  import Meeseeks.CSS

  @main_url "https://tinyurl.com/create.php"
  def gen(long_url) do
    params = [
      {:source, "indexpage"},
      {:url, URI.encode(long_url)}
    ]

    case @main_url |> HTTPoison.get([], [params: params]) do
      {:ok, response} ->
        response.body
        |> Meeseeks.one(css("#copy_div"))
        |> Meeseeks.attr("href")
      {:error, reason} ->
        reason
    end
  end
end

url = "https://www.zhihu.com/question/61803539/answers/updated"
url = "https://mp.weixin.qq.com/s?__biz=MzUxNjg2MTUxNQ==&mid=2247484225&idx=1&sn=0a3659c3425eb7befff37c2caa01c935&chksm=f9a1b865ced6317387a188b41edce83a9455954a010843586b4e5d46ad134f4988e4f913a231&token=811347497&lang=zh_CN#rd"
url = "https://mp.weixin.qq.com/s?__biz=MzU5MDY2MDc5Mg==&mid=2247484231&idx=1&sn=32d04544e032321c771a95f198d959a5&chksm=fe3b9690c94c1f869f307c6c47dc59aae85eb4e2c2784ae5332781b135c3fc684bee525d486a&scene=21#wechat_redirect"
AppExample.TinyUrl.gen(url) |> IO.inspect()


