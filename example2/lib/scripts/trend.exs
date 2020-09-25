defmodule AppExample.Trend do
  import Meeseeks.CSS

  @trend_url_map %{
    github: "https://github.com/trending"
  }

  def trend(:github) do
    case @trend_url_map[:github] |> HTTPoison.get() do
      {:ok, response} ->
        response.body
        |> Meeseeks.all(css(
          ".Box-row"
        ))
        |> Enum.map(
          fn el ->
            a_tag = el |> Meeseeks.one(css("h1.lh-condensed a"))
            intro = el |> Meeseeks.one(css("p.pr-4"))
            language = el |> Meeseeks.one(css("span[itemprop=programmingLanguage]"))
            star = el |> Meeseeks.one(css("a.muted-link.d-inline-block.mr-3"))
            %{
              title: a_tag |> Meeseeks.text(),
              link: a_tag |> Meeseeks.attr("href"),
              intro: intro |> Meeseeks.text(),
              language: language |> Meeseeks.text(),
              star: star |> Meeseeks.text()
            }
          end
        )
      {:error, reason} ->
        reason
    end
  end
end

AppExample.Trend.trend(:github) |> IO.inspect()
