defmodule ZygalskiSslUtilsTest do
  use ExUnit.Case

  setup_all do
    :meck.new(System)
    on_exit fn -> :meck.unload end
  end


  @private_key_args [
    "genrsa", "-des3", "-passout", "pass:the passphrase",
    "-out", "./keys/try_key.pem", "2048"
  ]
  @public_key_args [
    "rsa", "-in", "./keys/try_key.pem", "-passin", "pass:the passphrase",
    "-pubout", "-out", "./keys/try_key.pub"
  ]
  test "#create_pair, given a key_name and a passphrase, creates the private key" do
    :meck.expect(System, :cmd, fn("openssl", args) ->
      if (args != @private_key_args && args != @public_key_args), do: raise "ouch"
    end)

    Zygalski.SslUtils.create_pair("try_key", "the passphrase")
  end
end
