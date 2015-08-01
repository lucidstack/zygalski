defmodule ZygalskiKeyTest do
  use ExUnit.Case, async: true
  import Zygalski.Key

  test "#decode, given a key_content, returns a pem decoded key" do
    defmodule PublicKeyMock do
      def pem_decode("the_key_content"), do: ["entry"]
      def pem_entry_decode("entry"), do: "pemdecodedkey"
    end

    assert decode("the_key_content", PublicKeyMock) == "pemdecodedkey"
  end
end
