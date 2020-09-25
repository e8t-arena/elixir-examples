defmodule AppExample.Http do
  @moduledoc """
  ref: https://blog.appsignal.com/2019/01/22/serving-plug-building-an-elixir-http-server.html
  
  decoding requests and encoding responses
  accept HTTP requests and run a Plug application.

  mix run --no-halt 运行 application

  a server : like cowboy

  """

  require Logger

  def start_link(port: port) do
    # created a TCP server
    # 服务器监听端口
    {:ok, socket} = :gen_tcp.listen(
      port,
      active: false,
      packet: :http_bin,
      reuseaddr: true
    )
    Logger.info("Accepting connection on port #{port}")

    {:ok, spawn_link(__MODULE__, :accept, [socket])}
  end

  # Keyword List
  def start_link(port: port, dispatch: dispatch) do
    {:ok, socket} = :gen_tcp.listen(
      port,
      active: false,
      packet: :http_bin,
      reuseaddr: true
    )
    Logger.info("Accepting connection on port #{port}")

    {:ok, spawn_link(__MODULE__, :accept, [socket, dispatch])}
  end

  def accept(socket) do
    {:ok, request_socket} = :gen_tcp.accept(socket)
    # {:ok, request} = :gen_tcp.accept(socket)

    spawn(fn ->
      body = "Hello world! The time is #{Time.to_string(Time.utc_now())}"
      # 带换行符
      # 首行 状态行，然后 \r\n
      # header 多行 \r\n 分隔
      # 两个 \r\n (CRLFs)
      # 响应体
      response = """
      HTTP/1.1 200\r
      Content-Type: text/html\r
      Content-Length: #{byte_size(body)}\r
      \r
      #{body}
      """

      send_response(request_socket, response)
    end)
    accept(socket)
  end

  def accept(socket, dispatch) do
    {:ok, request_socket} = :gen_tcp.accept(socket)

    spawn(fn ->
      dispatch.(request_socket)
    end)

    accept(socket, dispatch)
  end

  def send_response(socket, response) do
    :gen_tcp.send(socket, response)
    :gen_tcp.close(socket)
  end

  def child_spec([port: port, dispatch: _]=opts) do
    %{
      id: {__MODULE__, port},
      start: {__MODULE__, :start_link, [opts]}
    }
  end

  def child_spec([port: port]=opts) do
    %{
      id: {__MODULE__, port},
      start: {__MODULE__, :start_link, [opts]}
    }
  end

  def read_request(request, acc \\ %{headers: [], full_path: ""}) do
    case :gen_tcp.recv(request, 0) do
      # {:ok, _} -> %{headers: [], full_path: ""}
      {:ok, {:http_request, :GET, {:abs_path, full_path},_}} ->
        read_request(request, Map.put(acc, :full_path, full_path))
      {:ok, :http_eoh} -> acc
      {:ok, {:http_header, _, key, _, value}} ->
        read_request(
          request,
          Map.put(
            acc, :headers,
            [
              {String.downcase(to_string(key)), value} | acc.headers
            ]
          )
        )
      {:ok, _line} -> read_request(request, acc)
      {:error, reason} ->
        Logger.info(reason)
        acc
    end
  end
end
