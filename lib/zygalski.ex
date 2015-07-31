defmodule Zygalski do
  use Application
  alias Zygalski.Router

  def start(_type, _args) do
    Plug.Adapters.Cowboy.http Router, [], port: port
    IO.puts("Zygalski Started!")

    {:ok, self()}
  end

  defp port,
  do: Application.get_env(:zygalski, :port)
end
