defmodule ZygalskiSslUtilsTest do
  use ExUnit.Case

  setup_all do
    :meck.new(System)
    on_exit fn -> :meck.unload end
  end

  test "#create_pair, given a key_name and a passphrase, creates the private key" do
    private_key_args = [
      "genrsa", "-des3", "-passout", "pass:the passphrase",
      "-out", "./keys/try_key.pem", "2048"
    ]
    public_key_args = [
      "rsa", "-in", "./keys/try_key.pem", "-passin", "pass:the passphrase",
      "-pubout", "-out", "./keys/try_key.pub"
    ]

    :meck.expect(System, :cmd, fn("openssl", private_key_args) -> true end)
    :meck.expect(System, :cmd, fn("openssl", public_key_args) -> true end)

    Zygalski.SslUtils.create_pair("try_key", "the passphrase")
  end
end
