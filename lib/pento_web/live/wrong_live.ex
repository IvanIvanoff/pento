defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, session, socket) do
    {:ok,
     assign(
       socket,
       score: 0,
       answer: Enum.random(1..10) |> to_string(),
       message: "Make a guess:",
       guessed_correctly?: false,
       session_id: session["live_socket_id"]
     )}
  end

  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <h1>Your score: <%= @score %></h1>
    <h2>
      <%= @message %>
    </h2>
    <%= if @guessed_correctly? do %>
      <.link patch={~p"/guess"}> Reset Game </.link>
    <% else %>
      <h2>
        <%= for n <- 1..10 do %>
          <.link href="#" phx-click="guess" phx-value-number={n}>
            <%= n %>
          </.link>
        <% end %>
        <pre>
          <%= @current_user.email %>
          <%= @session_id %>
        </pre>
      </h2>
    <% end %>
    """
  end

  def handle_event("guess", %{"number" => guess}, %{assigns: %{answer: guess}} = socket) do
    message = "Your guess: #{guess}. Correct!"

    score = socket.assigns.score + 1
    socket = put_flash(socket, :info, "You guessed correctly!")

    {
      :noreply,
      assign(socket, message: message, score: score, guessed_correctly?: true)
    }
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    message = "Your guess: #{guess}. Wrong. Guess again. "
    score = socket.assigns.score - 1

    {
      :noreply,
      assign(socket, message: message, score: score)
    }
  end

  def handle_params(_params, _uri, socket) do
    score = socket.assigns.score

    {:noreply,
     assign(socket,
       score: score,
       answer: Enum.random(1..10) |> to_string(),
       message: "Make a guess:",
       guessed_correctly?: false
     )}
  end
end
