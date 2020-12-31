defmodule Web do
  @moduledoc false

  import Plug.Conn

  def init(options) do
    IO.puts "Starting server at 127.0.0.1:4000"

    options
  end

  def call(conn, _opts) do
    IO.puts "Loading page 127.0.0.1:4000/"

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Hello world!")
  end
end
