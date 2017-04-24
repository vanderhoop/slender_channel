Application.ensure_all_started(:phoenix)

Code.require_file "support/channel_case.ex", __DIR__

endpoint_config = [
  server: false,
  pubsub: [
    adapter: Phoenix.PubSub.PG2,
    name: Phoenix.Test.ChannelTest.PubSub
  ]
]

Application.put_env(:phoenix, __MODULE__.Endpoint, endpoint_config)

defmodule Endpoint do
  use Phoenix.Endpoint, otp_app: :phoenix
end

ExUnit.start()
