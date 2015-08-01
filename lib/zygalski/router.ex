defmodule Zygalski.Router do
  alias Zygalski.SshUtil
  use Plug.Router

  plug Plug.Logger
  plug Plug.Parsers, parsers: [:urlencoded]
  plug :match
  plug :dispatch

  post "/new-key" do
    channel = conn.params["channel_name"]
    passphrase = conn.params["text"]
    SshUtil.create_key(channel, passphrase)

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Key created/updated!")
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
