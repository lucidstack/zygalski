defmodule ZygalskiKeyTest do
  use ExUnit.Case
  import Zygalski.Key

  setup_all do
    :meck.new(:public_key)
    on_exit &:meck.unload/0
  end

  test "#decode/1, given a key_content, returns a pem decoded key" do
    :meck.expect(:public_key, :pem_decode, fn("the_key_content") -> ["entry"] end)
    :meck.expect(:public_key, :pem_entry_decode, fn("entry") -> "pemdecodedkey" end)

    assert decode("the_key_content") == {:ok, "pemdecodedkey"}
  end

  test "#decode/2, given a key_content and a passphrase, returns a pem decoded key" do
    :meck.expect(:public_key, :pem_decode, fn("the_key_content") -> ["entry"] end)
    :meck.expect(:public_key, :pem_entry_decode, fn("entry", ["passphrase"]) -> "pemdecodedkey" end)

    assert decode("the_key_content", "passphrase") == {:ok, "pemdecodedkey"}
  end

  test "#decode/2, given a key_content and a wrong passphrase, returns an error tuple" do
    :meck.expect(:public_key, :pem_decode, fn("the_key_content") -> ["entry"] end)
    :meck.expect(:public_key, :pem_entry_decode, fn("entry", ["wrong"]) -> raise MatchError end)

    assert decode("the_key_content", "wrong") == {:error, :wrong_password}
  end
end
