defmodule AppExample.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: AppExample.Worker.start_link(arg)
      # {AppExample.Worker, arg}

      # {AppExample.Http, port: 8080},
      # {AppExample.Http.PlugAdapter, plug: AppExample.Http.CurrentTime, port: 8081},
      # {AppExample.Http.PlugAdapter, plug: Plug.Octopus, port: 8082},
      # {Plug.Cowboy, scheme: :http, plug: AppExample.Http.PlugHello, options: [port: 8083]}

      # # GenStage
      # {AppExample.GenStage.Example01.Producer, [0]},
      # {AppExample.GenStage.Example01.ProducerConsumer, []},
      # # {AppExample.GenStage.Example01.Consumer, [], id: :consumer_1},
      # # {AppExample.GenStage.Example01.Consumer, [], id: :consumer_2},
      # %{
      #   id: :consumer_1,
      #   # start: {AppExample.GenStage.Example01.Consumer, :start_link, []} # start_link/0
      #   start: {AppExample.GenStage.Example01.Consumer, :start_link, [[]]} # start_link/1
      # },
      # %{
      #   id: :consumer_2,
      #   start: {AppExample.GenStage.Example01.Consumer, :start_link, [[]]}
      # }
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AppExample.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
