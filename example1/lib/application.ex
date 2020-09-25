defmodule Example.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc "OTP Application specification for Example"

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      # Foo.Repo,
      # Start the endpoint when the application starts
      # FooWeb.Endpoint,

      # Starts a worker by calling: Foo.Worker.start_link(arg)
      # {Foo.Worker, arg},
      # {Redix, host: "0.0.0.0", name: :redix}

      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Example.Webhook.Endpoint,
        # options: [port: 4002]
        options: [port: Keyword.get(Application.get_env(:example, :webhook), :port) ]
      )
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Example.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
