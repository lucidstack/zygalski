defmodule ZygalskiRouterTest do
  use ExUnit.Case
  use Plug.Test

  setup_all do
    :meck.new(Zygalski.SslUtils)
    :meck.new(Zygalski.Crypto)
    on_exit fn -> :meck.unload end
  end

  @opts Zygalski.Router.init([])
  test "POST /new-key return a success message" do
    :meck.expect(
      Zygalski.SslUtils, :create_pair,
      fn("test", "the passphrase") -> true end
    )

    conn = conn(:post, "/new-key", "channel_name=test&text=the passphrase")
      |> put_req_header("content-type", "application/x-www-form-urlencoded")
      |> Zygalski.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "Key created/updated!"
  end

  test "POST /encrypt return the encrypted message" do
    :meck.expect(Zygalski.Crypto, :encrypt, fn("the passphrase", "test") -> "3ncrypt3d" end)

    conn = conn(:post, "/encrypt", "channel_name=test&text=the passphrase")
      |> put_req_header("content-type", "application/x-www-form-urlencoded")
      |> Zygalski.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "3ncrypt3d"
  end

  test "POST /decrypt return the decrypted message" do
    :meck.expect(Zygalski.Crypto, :decrypt, fn("3ncrypt3d", "the passphrase", "test") ->
      {:ok, "decrypted"}
    end)

    conn = conn(:post, "/decrypt", "channel_name=test&text=the passphrase 3ncrypt3d")
      |> put_req_header("content-type", "application/x-www-form-urlencoded")
      |> Zygalski.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "decrypted"
  end

  test "POST /decrypt return an error message when the password is wrong" do
    :meck.expect(Zygalski.Crypto, :decrypt, fn("3ncrypt3d", "the passphrase", "test") ->
      {:error, :wrong_password}
    end)

    conn = conn(:post, "/decrypt", "channel_name=test&text=the passphrase 3ncrypt3d")
      |> put_req_header("content-type", "application/x-www-form-urlencoded")
      |> Zygalski.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 401
    assert conn.resp_body == "Couldn't decrypt the message, wrong password!"
  end
end
