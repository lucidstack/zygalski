defmodule ZygalskiSslUtilsTest do
  use ExUnit.Case

  test "#create_pair, given a key_name and a passphrase, calls ssh_keygen" do
    defmodule SystemMock do
      @expected_array ["genrsa", "-des3", "-passout", "pass:the passphrase", "-out", "./keys/try_key.pem", 2048]
      def cmd("openssl", @expected_array), do: true
    end

    Zygalski.SslUtils.create_pair("try_key", "the passphrase", SystemMock)
  end
end
