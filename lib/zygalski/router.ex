defmodule Zygalski.Router do
  alias Zygalski.SslUtils
  alias Zygalski.Crypto
  use Plug.Router

  plug Plug.Logger
  plug Plug.Parsers, parsers: [:urlencoded]
  plug :match
  plug :dispatch

  post "/new-key" do
    channel = conn.params["channel_name"]
    passphrase = conn.params["text"]
    SslUtils.create_pair(channel, passphrase)

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Key created/updated!")
  end

  post "/encrypt" do
    key_name = conn.params["channel_name"]
    message = conn.params["text"]
    encrypted_message = Crypto.encrypt(message, key_name)

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, encrypted_message)
  end

  post "/decrypt" do
    key_name = conn.params["channel_name"]
    {passphrase, message} = conn.params["text"] |> extract_decrypt_text

    original_message = Crypto.decrypt(message, passphrase, key_name)

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, original_message)
  end

  match _ do
    send_resp(conn, 404, "oops")
  end

  defp extract_decrypt_text(text) do
    {passphrase, [message]} = text |> String.split |> Enum.split(-1)
    {passphrase |> Enum.join(" "), message}
  end
end
