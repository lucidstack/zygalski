defmodule ZygalskiSshUtilsTest do
  use ExUnit.Case

  test "#create_key, given a key_name and a passphrase, deletes the old keys" do
    defmodule SystemMock,
    do: (def cmd(_,_), do: true)

    defmodule FileMock do
      def rm("./keys/try_key"), do: true
      def rm("./keys/try_key.pub"), do: true
    end

    Zygalski.SshUtil.create_key("try_key", "whatever", SystemMock, FileMock)
  end

  test "#create_key, given a key_name and a passphrase, calls ssh_keygen" do
    defmodule SystemMock do
      @expected_array ["-t", "rsa", "-N", "the passphrase", "-f", "./keys/try_key"]
      def cmd("ssh-keygen", @expected_array), do: true
    end

    defmodule FileMock,
    do: (def rm(_), do: true)

    Zygalski.SshUtil.create_key("try_key", "the passphrase", SystemMock, FileMock)
  end
end
