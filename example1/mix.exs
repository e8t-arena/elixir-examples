defmodule Example.MixProject do
  use Mix.Project

  def project do
    [
      app: :example,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :plug_cowboy],
      applications: [:timex, :amqp],
      mod: {Example.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:timex, "~> 3.0"},
      {:httpoison, "~> 1.4"},
      # {:elixir_mbcs, github: "woxtu/elixir-mbcs", tag: "0.1.3"},
      # {:iconv, "~> 1.0.10"},
      {:jason, "~> 1.1"},
      {:benchee, "~> 1.0", only: :dev},
      {:redix, ">= 0.0.0"},
      {:amqp, "~> 1.2"},
      {:plug_cowboy, "~> 2.0"},
      {:poison, "~> 3.1"}
      # mix deps.get
      # mix compile
    ]
  end
end
