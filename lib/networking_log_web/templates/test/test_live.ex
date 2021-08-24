defmodule NetworkingLogWeb.TestLive do
  use NetworkingLogWeb, :live_view
  use Phoenix.LiveView
  def mount(_params, _session, socket) do
    mounted_socket = socket
    |> assign(:click, false)

    IO.inspect(mounted_socket, label: "new socket in mount")

    {:ok, mounted_socket}
  end
end
