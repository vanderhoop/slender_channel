defmodule SlenderChannelTest do
  use SlenderChannel.ChannelCase, async: true

  import Mock

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

    handle_in_and_broadcast("video_game", payload)
    handle_in_and_broadcast!("nonsense", payload)
    handle_in_and_broadcast_from("radio", payload)
    handle_in_and_broadcast_from!("new_idea", payload)
  end

  describe "the handler defined by handle_in_and_broadcast/2" do
    test "handles the matched event and payload, broadcasting them in turn" do
      socket = subscribe_and_join!(socket(), SandboxChannel, "room:lobby")

      push socket, "video_game", %{"pessi" => "myst"}
      assert_broadcast "video_game", %{"pessi" => "myst"}
    end

    test "provides a success reply by default" do
      socket = subscribe_and_join!(socket(), SandboxChannel, "room:lobby")

      ref = push socket, "video_game", %{}
      assert_reply ref, :ok
    end

    test "provides an error reply when the broadcast fails" do
      with_mock Phoenix.Channel,
        broadcast: fn _, _, _ ->
          {:error, :disconnect}
        end do

        socket = subscribe_and_join!(socket(), SandboxChannel, "room:lobby")

        ref = push socket, "video_game", %{}
        assert_reply ref, :error
      end
    end
  end

  describe "the handler defined by handle_in_and_broadcast!/2" do
    test "handles the matched event and payload, broadcasting them in turn" do
      socket = subscribe_and_join!(socket(), SandboxChannel, "room:lobby")

      refute_broadcast "nonsense", _params
      push socket, "nonsense", %{"blurg" => "tastic"}
      assert_broadcast "nonsense", %{"blurg" => "tastic"}
    end
  end

  describe "the handler defined by handle_in_and_broadcast_from/2" do
    test "handles the matched event and payload, broadcasting them to all *other* clients" do
      socket = subscribe_and_join!(socket(), SandboxChannel, "room:lobby")

      push socket, "radio", %{"free" => "europe"}
      assert_broadcast_to_other_clients_only "radio", %{"free" => "europe"}
    end

    test "provides a success reply by default" do
      socket = subscribe_and_join!(socket(), SandboxChannel, "room:lobby")

      ref = push socket, "radio", %{}
      assert_reply ref, :ok
    end

    test "provides an error reply when the broadcast fails" do
      with_mock Phoenix.Channel,
        broadcast_from: fn _, _, _ ->
          {:error, :disconnect}
        end do

        socket = subscribe_and_join!(socket(), SandboxChannel, "room:lobby")

        ref = push socket, "radio", %{}
        assert_reply ref, :error
      end
    end
  end

  describe "the handler defined by handle_in_and_broadcast_from!/2" do
    test "handles the matched event and payload, broadcasting them in turn" do
      socket = subscribe_and_join!(socket(), SandboxChannel, "room:lobby")

      push socket, "new_idea", %{"cold" => "soda"}
      assert_broadcast_to_other_clients_only("new_idea", %{"cold" => "soda"})
    end
  end
end
