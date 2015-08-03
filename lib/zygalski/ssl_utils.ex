defmodule Zygalski.SslUtils do
  def create_pair(key_name, passphrase, system \\ System) do
    system.cmd("openssl", private_key_args(key_name, passphrase))
    #system.cmd("openssl", public_key_args(key_name, passphrase))
  end

  def key_path(key_name),
  do: Path.join([Application.get_env(:zygalski, :keys_path), key_name])

  defp private_key_args(key_name, passphrase),
  do: [
    "genrsa",
    "-#{key_type}", "-passout", "pass:#{passphrase}",
    "-out", "./keys/#{key_name}.pem",
    2048
  ]

  defp key_type,
  do: Application.get_env(:zygalski, :key_type)
end
