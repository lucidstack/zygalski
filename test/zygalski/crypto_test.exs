defmodule ZygalskiCryptoTest do
  use ExUnit.Case

  setup_all do
    :meck.new(File)
    :meck.new(:public_key)
    :meck.new(Zygalski.Key)
    :meck.new(Base)
    on_exit fn -> :meck.unload end
  end

  test "#encrypt, given a message and a key_name, returns the encrypted message" do
    :meck.expect(File,         :read,           fn(_) -> {:ok, "thekeycontent"} end)
    :meck.expect(Zygalski.Key, :decode,         fn(_) -> {:ok, "key"} end)
    :meck.expect(:public_key,  :encrypt_public, fn("the message","key") -> "3ncrypt3d m3ss4g3" end)
    :meck.expect(Base,         :encode64,       fn(_) -> "encoded" end)

    assert Zygalski.Crypto.encrypt("the message", "the_key") == {:ok, "encoded"}
  end

  test "#decrypt, given a message, a passphrase, and a key_name, returns the decrypted message" do
    :meck.expect(File,         :read,            fn(_) -> {:ok, "thekeycontent"} end)
    :meck.expect(:public_key,  :decrypt_private, fn(_,_) -> "decrypted message" end)
    :meck.expect(Zygalski.Key, :decode,          fn(_, "password") -> {:ok, "key"} end)
    :meck.expect(Base,         :decode64,        fn(_) -> {:ok, "blahblah"} end)

    assert Zygalski.Crypto.decrypt("3ncrypt3d m3ss4g3", "password", "the_key") == {:ok, "decrypted message"}
  end
end
