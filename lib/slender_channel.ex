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
  the given event and payload, broadcasting them in turn to all connected clients:

      handle_in_and_broadcast "bobby_dumped_stacy", %{"pettiness" => 10}

  Becomes:

      def handle_in("bobby_dumped_stacy", %{"pettiness" => 10}, socket) do
        Phoenix.Channel.broadcast! socket, "bobby_dumped_stacy", %{"pettiness" => 10}
        {:noreply, socket}
      end

  """
  defmacro handle_in_and_broadcast!(event, payload) do
    quote do
      def handle_in(unquote(event), unquote(payload), socket) do
        Phoenix.Channel.broadcast! socket, unquote(event), unquote(payload)
        {:noreply, socket}
      end
    end
  end

  @doc """
  Defines a `handle_in/3` callback that pattern matches
  the given event and payload, broadcasting them to all *other* clients:

      handle_in_and_broadcast_from "urgent message", %{"ETA" => "10 minutes"}

  Becomes:

      def handle_in("urgent message", %{"ETA" => "10 minutes"}, socket) do
        Phoenix.Channel.broadcast_from! socket, "urgent message", %{"ETA" => "10 minutes"}
        {:noreply, socket}
      end

  """
  defmacro handle_in_and_broadcast_from!(event, payload) do
    quote do
      def handle_in(unquote(event), unquote(payload), socket) do
        Phoenix.Channel.broadcast_from! socket, unquote(event), unquote(payload)
        {:noreply, socket}
      end
    end
  end
end
