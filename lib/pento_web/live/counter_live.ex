defmodule PentoWeb.CounterLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, counter: 0)}
  end

  def render(assigns) do
    ~H"""
    <h1 class="mb-3 text-2xl font-bold">Counter: <%= @counter %></h1>
    <.button phx-click="inc">+1</.button>
    <.button phx-click="dec">-1</.button>
    """
  end

  def handle_event("inc", _params, socket) do
    {:noreply, assign(socket, counter: socket.assigns.counter + 1)}
  end

  def handle_event("dec", _params, socket) do
    {:noreply, assign(socket, counter: socket.assigns.counter - 1)}
  end
end
