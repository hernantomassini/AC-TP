defmodule SubastaAutomatica.MixProject do
  use Mix.Project

  def project do
    [
      app: :subastaautomatica,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :cowboy, :plug, :poison, :elixir_uuid],
      mod: {Server.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cowboy, "~> 1.0.0"},
      {:plug, "~> 1.5"},
      {:httpoison, "~> 1.0"},
      {:poison, "~> 3.1"},
      {:elixir_uuid, "~> 1.2" }
    ]
  end
end
