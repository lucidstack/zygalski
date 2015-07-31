defmodule Zygalski.Router do
  alias Zygalski.SshUtil
  use Plug.Router

  plug Plug.Logger
  plug :match
  plug :dispatch

  get "/new-key" do
    query = Plug.Conn.Query.decode(conn.query_string)
    channel = query["channel_name"]
    passphrase = query["text"]
    SshUtil.create_key(channel, passphrase)

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Key created/updated!")
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
