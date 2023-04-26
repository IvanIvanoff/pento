defmodule PentoWeb.ChatLive do
  use PentoWeb, :live_view

  @topic "chat"

  def mount(_params, _session, socket) do
    if connected?(socket) do
      PentoWeb.Endpoint.subscribe(@topic)
    end

    messages = []

    {:ok,
     socket
     |> stream(:messages, messages)}
  end

  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <div>
      <div
        id="messages"
        class="flex-1 p:2 sm:p-6 justify-between flex flex-col overflow-y-auto scrolling-auto h-96"
      >
        <.table id="messages" rows={@streams.messages}>
          <:col :let={{_id, message}} label="User"><%= message.user %></:col>
          <:col :let={{_id, message}} label="Message"><%= message.text %></:col>
        </.table>
      </div>

      <form phx-submit="send_msg">
        <input type="text" name="text" />
        <button type="submit">Send</button>
      </form>
    </div>
    """
  end

  def handle_event("send_msg", %{"text" => text}, socket) do
    email =
      socket.assigns.current_user.email

    message = %{inserted_at: time(), text: text, user: email, id: Ecto.UUID.generate()}

    PentoWeb.Endpoint.broadcast_from(self(), @topic, "new_msg", message)

    {:noreply,
     socket
     |> stream_insert(:messages, message)}
  end

  def handle_info(%{event: "new_msg", payload: message}, socket) do
    {:noreply,
     socket
     |> stream_insert(:messages, message)}
  end

  def time() do
    DateTime.utc_now() |> DateTime.truncate(:second) |> to_string()
  end
end
