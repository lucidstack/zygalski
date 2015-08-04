defmodule Zygalski.Key do
  def decode(key_content) do
    [entry] = :public_key.pem_decode key_content
    :public_key.pem_entry_decode entry
  end

  def decode(key_content, password) do
    [entry] = :public_key.pem_decode key_content
    :public_key.pem_entry_decode entry, [password]
  end
end
