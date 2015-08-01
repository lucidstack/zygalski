defmodule Zygalski.Crypto do
  alias Zygalski.Key
  alias Zygalski.SshUtils

  def encrypt(message, key_name, public_key \\ :public_key, file \\ File, key \\ Key) do
    key_content = key_content(key_name, file)
    message |> public_key.encrypt_public(key.decode(key_content))
  end

  def decrypt(cipher_text, key_name, password, public_key \\ :public_key, file \\ File, key \\ Key) do
    key_content = key_content(key_name, file)
    cipher_text |> public_key.decrypt_private(key.decode_with_password(key_content, password))
  end

  defp key_content(key_name, file) do
    {:ok, key_content} = file.read(SshUtils.key_path(key_name))
    key_content
  end
end
