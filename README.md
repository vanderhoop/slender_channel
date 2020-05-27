[![CircleCI](https://circleci.com/gh/vanderhoop/slender_channel.svg?style=shield)](https://circleci.com/gh/stride-nyc/remote_retro)
[![Hex.pm](https://img.shields.io/hexpm/v/slender_channel.svg)]()

# SlenderChannel

A small, dependency-free module that exposes helpful macros for working with Phoenix Channels.

## Usage

The package can be installed by adding `slender_channel` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:slender_channel, "~> 0.2.0"}]
end
```

To leverage `SlenderChannel`'s macros, simply `use` it within your Phoenix Channel:

```elixir
defmodule YourPhoenixApp.YourChannel do
  use YourPhoenixApp.Web, :channel
  use SlenderChannel

  # ...
end
```

And leverage the macros within said channel.

```elixir
handle_in_and_broadcast "bobby_dumped_stacy", %{"pettiness" => 10}

handle_in_and_broadcast_from "urgent message", %{"ETA" => "10 minutes"}
```

Under the hood, becomes:

```elixir
def handle_in("bobby_dumped_stacy", %{"pettiness" => 10}, socket)
  Phoenix.Channel.broadcast! socket, "bobby_dumped_stacy", %{"pettiness" => 10}
  {:noreply, socket}
end

def handle_in("urgent message", %{"ETA" => "10 minutes"}, socket) do
  Phoenix.Channel.broadcast_from! socket, "urgent message", %{"ETA" => "10 minutes"}
  {:noreply, socket}
end
```

