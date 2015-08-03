defmodule Zygalski.Crypto do
  alias Zygalski.Key
  alias Zygalski.SslUtils

  def encrypt(message, key_name, public_key \\ :public_key, file \\ File, key \\ Key) do
    key = key_name |> key_content(:public, file) |> key.decode
    message |> public_key.encrypt_public(key) |> Base.encode64
  end

  def decrypt(cipher_text, key_name, password, public_key \\ :public_key, file \\ File, key \\ Key) do
    key = key_name |> key_content(:private, file) |> key.decode_with_password(password)
    cipher_text |> Base.decode64 |> public_key.decrypt_private(key)
  end

  defp key_content(key_name, type, file) do
    {:ok, key_content} = SslUtils.key_path(key_name, type) |> file.read
    key_content
  end
end
