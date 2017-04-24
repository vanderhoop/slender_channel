defmodule SlenderChannelTest do
  use SlenderChannel.ChannelCase, async: true

  defmodule SandboxChannel do
    use Phoenix.Channel
    use SlenderChannel

    def join("room:lobby", _, socket) do
      {:ok, socket}
    end

    handle_in_and_broadcast "nonsense", %{"blurg" => "tastic"}
  end

  describe "handle_in_and_broadcast/2" do
    test "handles the given event and message, broadcasting them in turn" do
      socket = subscribe_and_join!(socket(), SandboxChannel, "room:lobby")

      refute_broadcast "nonsense", _params
      push socket, "nonsense", %{"blurg" => "tastic"}
      assert_broadcast "nonsense", %{"blurg" => "tastic"}
    end
  end
end
