defmodule ZygalskiRouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  setup_all do
    :meck.new(Zygalski.SshUtil)
    on_exit fn -> :meck.unload end
  end

  @opts Zygalski.Router.init([])
  test "POST /new-key return a success message" do
    :meck.expect(
      Zygalski.SshUtil, :create_key,
      fn("test", "the passphrase") -> true end
    )

    conn = conn(:post, "/new-key", "channel_name=test&text=the passphrase")
      |> put_req_header("content-type", "application/x-www-form-urlencoded")
      |> Zygalski.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "Key created/updated!"
  end
end
