defmodule ZygalskiSslUtilsTest do
  use ExUnit.Case

  test "#create_pair, given a key_name and a passphrase, creates the private key" do
    defmodule SystemMock do
      @private_key_args [
        "genrsa",
        "-des3", "-passout", "pass:the passphrase",
        "-out", "./keys/try_key.pem", 2048
      ]
      @public_key_args [
        "rsa",
        "-in", "./keys/try_key.pem", "-passin", "pass:the passphrase",
        "-pubout", "-out", "./keys/try_key.pub"
      ]
      def cmd("openssl", @private_key_args), do: true
      def cmd("openssl", @public_key_args), do: true
    end

    Zygalski.SslUtils.create_pair("try_key", "the passphrase", SystemMock)
  end
end
