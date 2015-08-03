defmodule Zygalski.SslUtils do
  def create_pair(key_name, passphrase, system \\ System) do
    system.cmd("openssl", private_key_args(key_name, passphrase))
    system.cmd("openssl", public_key_args(key_name, passphrase))
  end

  defp private_key_args(key_name, passphrase),
  do: [
    "genrsa",
    "-#{key_type}", "-passout", "pass:#{passphrase}",
    "-out", key_path(key_name, :private),
    2048
  ]

  defp public_key_args(key_name, passphrase),
  do: [
    "rsa",
    "-in", key_path(key_name, :private), "-passin", "pass:#{passphrase}",
    "-pubout", "-out", key_path(key_name, :public)
  ]

  defp key_type,
  do: Application.get_env(:zygalski, :key_type)

  def key_path(key_name, :public),
  do: Path.join([Application.get_env(:zygalski, :keys_path), key_name <> ".pub"])

  def key_path(key_name, :private),
  do: Path.join([Application.get_env(:zygalski, :keys_path), key_name <> ".pem"])
end
