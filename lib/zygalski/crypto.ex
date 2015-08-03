defmodule Zygalski.Crypto do
  alias Zygalski.Key
  alias Zygalski.SslUtils

  def encrypt(message, key_name, public_key \\ :public_key, file \\ File, key \\ Key) do
    key_content = key_content(key_name, file, :public)
    message |> public_key.encrypt_public(key.decode(key_content))
  end

  def decrypt(cipher_text, key_name, password, public_key \\ :public_key, file \\ File, key \\ Key) do
    key_content = key_content(key_name, file, :private)
    cipher_text |> public_key.decrypt_private(key.decode_with_password(key_content, password))
  end

  defp key_content(key_name, file, type) do
    {:ok, key_content} = SslUtils.key_path(key_name, type) |> file.read
    key_content
  end
end
