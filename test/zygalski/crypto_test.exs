defmodule ZygalskiCryptoTest do
  use ExUnit.Case
  import Zygalski.Crypto

  test "#encrypt, given a message and a key_name, returns the encrypted message" do
    defmodule FileMock,
    do: (def read(_), do: {:ok, "thekeycontent"})

    defmodule PublicKeyMock,
    do: (def encrypt_public(_,_), do: "3ncrypt3d m3ss4g3")

    defmodule KeyMock,
    do: (def decode(_), do: true)

    assert encrypt(
      "the message", "the_key",
      PublicKeyMock, FileMock, KeyMock
    ) == "3ncrypt3d m3ss4g3"
  end

  test "#decrypt, given a message, a passphrase, and a key_name, returns the decrypted message" do
    defmodule FileMock,
    do: (def read(_), do: {:ok, "thekeycontent"})

    defmodule PublicKeyMock,
    do: (def decrypt_private(_,_), do: "decrypted message")

    defmodule KeyMock,
    do: (def decode_with_password(_,_), do: true)

    assert decrypt(
      "3ncrypt3d m3ss4g3", "the_key", "password",
      PublicKeyMock, FileMock, KeyMock
    ) == "decrypted message"
  end
end
