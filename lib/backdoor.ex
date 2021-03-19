defmodule Backdoor do
  def server(port) do
    {:ok, listen_socket} = :gen_tcp.listen(port, [:binary, reuseaddr: true])
    server_handler(listen_socket)
  end

  def server_handler(listen_socket) do
    {:ok, socket} = :gen_tcp.accept(listen_socket)
    :ok = :gen_tcp.send(socket, "hello\n")
    #:ok = :gen_tcp.shutdown(socket, :read_write)
    server_handler(listen_socket)
  end

  def client(port) do
    {:ok, socket} = :gen_tcp.connect('localhost', port, [:binary, active: true])
    client_handler(socket)
  end

  def client_handler(socket) do
    receive do
      {:tcp, ^socket, data} ->
        IO.write data
        client_handler(socket)
      {:tcp_closed, ^socket} ->
        IO.puts "connection closed"
    end
  end
end
