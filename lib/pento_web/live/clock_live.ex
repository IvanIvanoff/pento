defmodule PentoWeb.ClockLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    Process.send_after(self(), :tick, 10)
    {:ok, assign(socket, time: time())}
  end

  def render(assigns) do
    ~H"""
    <h1>Time now: <%= @time %></h1>
    """
  end

  def handle_info(:tick, socket) do
    Process.send_after(self(), :tick, 10)
    {:noreply, assign(socket, time: time())}
  end

  def time() do
    DateTime.utc_now() |> DateTime.truncate(:millisecond) |> to_string()
  end
end
