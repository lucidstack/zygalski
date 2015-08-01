defmodule Zygalski.SshUtils do
  def create_key(key_name, passphrase, system \\ System, file \\ File) do
    delete_existing_key(key_name, file)
    call_ssh_keygen(key_name, passphrase, system)
  end

  def key_path(key_name),
  do: Path.join([Application.get_env(:zygalski, :keys_path), key_name])

  defp delete_existing_key(key_name, file) do
    file.rm(key_path(key_name))
    file.rm(key_path(key_name <> ".pub"))
  end

  defp call_ssh_keygen(key_name, passphrase, system),
  do: system.cmd("ssh-keygen", ssh_args(key_name, passphrase))

  defp ssh_args(key_name, passphrase),
  do: ["-t", key_type, "-N", passphrase, "-f", key_path(key_name)]

  defp key_type,
  do: Application.get_env(:zygalski, :key_type)
end
