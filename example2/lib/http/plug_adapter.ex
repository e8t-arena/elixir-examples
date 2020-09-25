defmodule AppExample.Http.PlugAdapter do
  @moduledoc """
  To make sure our web server can communicate with our web application, we need to build a %Plug.Conn{} struct to pass to CurrentTime.call/2

  还要将 response 转为 string
  """
  def dispatch(request, plug) do
    %{full_path: full_path} = AppExample.Http.read_request(request) |> IO.inspect

    %Plug.Conn{
      adapter: {__MODULE__, request},
      owner: self(),
      path_info: path_info(full_path),
      query_string: query_string(full_path)
    }
    |> plug.call([])
  end

  def send_resp(socket, status, headers, body) do
    response = "HTTP/1.1 #{status}\r\n#{make_headers(headers)}\r\n#{body}"
    AppExample.Http.send_response(socket, response)
    {:ok, nil, socket}
  end

  def child_spec(plug: plug, port: port) do
    AppExample.Http.child_spec(port: port, dispatch: &dispatch(&1, plug))
  end

  defp make_headers(headers) do
    Enum.reduce(headers, "", fn {key, value}, acc ->
      acc <> key <> ": " <> value <> "\r\n"
    end)
  end

  defp path_info(full_path) do
    [path | _] = String.split(full_path, "?")
    path |> String.split("/") |> Enum.reject(&(&1==""))
  end

  defp query_string([_]), do: ""
  defp query_string([_, query_string]), do: query_string
  defp query_string(full_path) do
    full_path |> String.split("?") |> query_string
  end
end
