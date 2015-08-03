defmodule ZygalskiCryptoTest do
  use ExUnit.Case
  import Zygalski.Crypto

  setup_all do
    :meck.new(File)
    :meck.new(:public_key)
    :meck.new(Zygalski.Key)
    on_exit fn -> :meck.unload end
  end

  test "#encrypt, given a message and a key_name, returns the encrypted message" do
    :meck.expect(File,         :read,           fn(_) -> {:ok, "thekeycontent"} end)
    :meck.expect(:public_key,  :encrypt_public, fn(_,_) -> "3ncrypt3d m3ss4g3" end)
    :meck.expect(Zygalski.Key, :decode,         fn(_) -> true end)

    assert encrypt("the message", "the_key") == "M25jcnlwdDNkIG0zc3M0ZzM="
  end

  test "#decrypt, given a message, a passphrase, and a key_name, returns the decrypted message" do
    :meck.expect(File,         :read,                 fn(_) -> {:ok, "thekeycontent"} end)
    :meck.expect(:public_key,  :decrypt_private,      fn(_,_) -> "decrypted message" end)
    :meck.expect(Zygalski.Key, :decode_with_password, fn(_,_) -> true end)

    assert decrypt("3ncrypt3d m3ss4g3", "the_key", "password") == "decrypted message"
  end
end
