defmodule Zygalski.Key do
  def decode(key_content) do
    [entry] = :public_key.pem_decode key_content
    key = :public_key.pem_entry_decode entry

    {:ok, key}
  end

  def decode(key_content, password) do
    try do
      [entry] = :public_key.pem_decode key_content
      key = :public_key.pem_entry_decode entry, [password]

      {:ok, key}
    rescue
      MatchError -> {:error, :wrong_password}
    end
  end
end
