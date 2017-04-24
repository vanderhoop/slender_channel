defmodule SlenderChannel.ChannelCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Phoenix.ChannelTest
      @moduletag :capture_log

      @endpoint Endpoint

      setup_all do
        @endpoint.start_link()
        :ok
      end
    end
  end
end
