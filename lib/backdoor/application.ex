defmodule Backdoor.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      %{
        id: Backdoor,
        start: {Backdoor.Listener, :accept, [5555]}
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
