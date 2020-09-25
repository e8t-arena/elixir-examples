defmodule AppExample.MixProject do
  use Mix.Project

  def project do
    [
      app: :app_example,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {AppExample.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:plug_octopus, github: "jeffkreeftmeijer/plug_octopus"},
      {:plug_cowboy, "~> 2.0"},
      {:redix, "~> 0.10.2"},
      {:jason, "~> 1.1"},
      {:httpoison, "~> 1.4"},
      # html parser
      {:meeseeks, "~> 0.12.0"},
      {:gen_stage, "~> 0.14"},
      {:tesla, "~> 1.2.1"},
    ]
  end
end
