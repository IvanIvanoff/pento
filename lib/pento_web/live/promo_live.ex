defmodule PentoWeb.PromoLive do
  use PentoWeb, :live_view

  alias Pento.Promo
  alias Pento.Promo.Recipient

  def mount(_params, _session, socket) do
    recipient = %Recipient{}
    changeset = Promo.change_recipient(recipient)

    {:ok,
     socket
     |> assign(:recipient, recipient)
     |> assign_form(changeset)}
  end

  def handle_event("validate", %{"recipient" => recipient_params}, socket) do
    changeset =
      socket.assigns.recipient
      |> Promo.change_recipient(recipient_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  defp assign_form(socket, changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
