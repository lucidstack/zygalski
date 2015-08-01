defmodule Zygalski.Key do
  def decode(key_content, public_key \\ :public_key) do
    [entry] = public_key.pem_decode key_content
    public_key.pem_entry_decode entry
  end

  def decode_with_password(key_content, password, public_key \\ :public_key) do
    [entry] = public_key.pem_decode key_content
    public_key.pem_entry_decode entry, password
  end
end
