defmodule SlenderChannel.Mixfile do
  use Mix.Project

  def project do
    [
      app: :slender_channel,
      version: "0.2.0",
      elixir: "~> 1.3",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      description: "Exposes helpful macros for working with Phoenix Channels",
      deps: deps(),
      package: package()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:phoenix, github: "phoenixframework/phoenix", only: :test}
    ]
  end

  defp package do
    [
      maintainers: ["Travis Vander Hoop"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/vanderhoop/slender_channel"}
    ]
  end
end
