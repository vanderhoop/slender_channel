defmodule SlenderChannelTest do
  use SlenderChannel.ChannelCase, async: true

  # these assertions require macros so that we can pass a pattern to match
  defmacro assert_broadcast_to_other_clients_only(message, match) do
    quote do
      assert_broadcast(unquote(message), unquote(match))
      refute_push(unquote(message), unquote(match))
    end
  end

  defmodule SandboxChannel do
    use Phoenix.Channel
    use SlenderChannel

    def join("room:lobby", _, socket) do
      {:ok, socket}
    end

    handle_in_and_broadcast! "nonsense", %{"blurg" => "tastic"}
    handle_in_and_broadcast_from! "new_idea", %{"cold" => "soda"}
  end

  describe "handle_in_and_broadcast!/2" do
    test "handles the given event and message, broadcasting them in turn" do
      socket = subscribe_and_join!(socket(), SandboxChannel, "room:lobby")

      refute_broadcast "nonsense", _params
      push socket, "nonsense", %{"blurg" => "tastic"}
      assert_broadcast "nonsense", %{"blurg" => "tastic"}
    end
  end

  describe "handle_in_and_broadcast_from!/2" do
    test "handles the given event and message, broadcasting them in turn" do
      socket = subscribe_and_join!(socket(), SandboxChannel, "room:lobby")

      push socket, "new_idea", %{"cold" => "soda"}
      assert_broadcast_to_other_clients_only("new_idea", %{"cold" => "soda"})
    end
  end
end
