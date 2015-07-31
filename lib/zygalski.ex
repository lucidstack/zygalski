defmodule Zygalski do
  alias Zygalski.Router

  def start do
    Plug.Adapters.Cowboy.http Router, [], port: 6553
  end
end
