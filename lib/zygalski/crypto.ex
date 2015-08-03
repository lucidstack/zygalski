defmodule Zygalski.Crypto do
  alias Zygalski.Key
  alias Zygalski.SslUtils

  def encrypt(message, key_name) do
    key = key_name |> key_content(:public) |> Key.decode
    message |> :public_key.encrypt_public(key) |> Base.encode64
  end

  def decrypt(cipher_text, key_name, password) do
    key = key_name |> key_content(:private) |> Key.decode_with_password(password)
    cipher_text |> Base.decode64 |> :public_key.decrypt_private(key)
  end

  defp key_content(key_name, type) do
    {:ok, key_content} = SslUtils.key_path(key_name, type) |> File.read
    key_content
  end
end
