defmodule Zygalski.Crypto do
  alias Zygalski.SslUtils

  def encrypt(message, key_name) do
    {:ok, public_key} = key(key_name, :public)
    encrypted_message = message |> :public_key.encrypt_public(public_key) |> Base.encode64

    {:ok, encrypted_message}
  end

  def decrypt(cipher_text, password, key_name) do
    private_key = key(key_name, :private, password)
    decrypt_with_key(private_key, cipher_text)
  end

  defp decrypt_with_key({:ok, key}, cipher_text) do
    message = cipher_text |> decode_cipher_text |> :public_key.decrypt_private(key)
    {:ok, message}
  end

  defp decrypt_with_key({:error, _}, cipher_text),
  do: {:error, :wrong_password}

  defp decode_cipher_text(message) do
    {:ok, decoded_message} = message |> Base.decode64
    decoded_message
  end

  defp key_content(key_name, type) do
    {:ok, key_content} = SslUtils.key_path(key_name, type) |> File.read
    key_content
  end

  defp key(key_name, :private, password),
  do: key_name |> key_content(:private) |> Zygalski.Key.decode(password)

  defp key(key_name, :public),
  do: key_name |> key_content(:public) |> Zygalski.Key.decode
end
