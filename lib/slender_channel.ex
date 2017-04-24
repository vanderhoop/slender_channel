defmodule SlenderChannel do
  @moduledoc """
  Exposes helpful macros for working with Phoenix Channels
  """

  defmacro __using__(_opts) do
    quote do
      import SlenderChannel
    end
  end

  @doc """
  Defines a `handle_in/3` callback that pattern matches
  the given event and payload, broadcasting them in turn:

      handle_in_and_broadcast "bobby_dumped_stacy", %{"pettiness" => 10}

  Becomes:

      def handle_in("bobby_dumped_stacy", %{"pettiness" => 10}, socket) do
        broadcast! socket, "bobby_dumped_stacy", %{"pettiness" => 10}
        {:noreply, socket}
      end

  """
  defmacro handle_in_and_broadcast(event, payload) do
    quote do
      def handle_in(unquote(event), unquote(payload), socket) do
        broadcast! socket, unquote(event), unquote(payload)
        {:noreply, socket}
      end
    end
  end
end
