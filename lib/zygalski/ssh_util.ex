defmodule Zygalski.SshUtil do
  def create_key(key_name, passphrase) do
    delete_existing_key(key_name)
    call_ssh_keygen(key_name, passphrase)
  end

  defp delete_existing_key(key_name) do
    File.rm(key_path(key_name))
    File.rm(key_path(key_name <> ".pub"))
  end

  defp call_ssh_keygen(key_name, passphrase),
  do: System.cmd("ssh-keygen", ssh_args(key_name, passphrase))

  defp ssh_args(key_name, passphrase),
  do: ["-t", key_type, "-N", passphrase, "-f", key_path(key_name)]

  defp key_type,
  do: Application.get_env(:zygalski, :key_type)

  defp key_path(key_name),
  do: Path.join([Application.get_env(:zygalski, :keys_path), key_name])
end
