defmodule Zygalski.Crypto do
  alias Zygalski.Key
  alias Zygalski.SslUtils

  def encrypt(message, key_name) do
    key = key_name |> key_content(:public) |> Key.decode
    message |> :public_key.encrypt_public(key) |> Base.encode64
  end

  def decrypt(cipher_text, password, key_name) do
    key = key_name |> key_content(:private) |> Key.decode(password)
    cipher_text |> decode_cipher_text |> :public_key.decrypt_private(key)
  end

  defp key_content(key_name, type) do
    {:ok, key_content} = SslUtils.key_path(key_name, type) |> File.read
    key_content
  end

  defp decode_cipher_text(message) do
    {:ok, decoded_message} = message |> Base.decode64
    decoded_message
  end
end
