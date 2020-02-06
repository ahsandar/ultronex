defmodule UltronEx.MixProject do
  use Mix.Project

  def project do
    [
      app: :ultronex,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript()
    ]
  end

  def escript do
    [main_module: UltronexApp]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [
        :logger,
        :cowboy,
        :plug,
        :plug_cowboy,
        :eex,
        :logger_file_backend,
        :appsignal
      ],
      mod: {UltronexApp, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:slack, "~> 0.20.0"},
      {:new_relic_agent, "~> 1.0"},
      {:cowboy, "~> 2.7.0"},
      {:plug, "~> 1.8.3"},
      {:plug_cowboy, "~> 2.1.0"},
      {:dialyxir, "~> 0.4", only: [:dev]},
      {:basic_auth, "~> 2.2.2"},
      {:logger_file_backend, "~> 0.0.10"},
      {:credo, "~> 1.1.0", only: [:dev, :test], runtime: false},
      {:sentry, "~> 7.0"},
      {:jason, "~> 1.1"},
      {:appsignal, "~> 1.0"},
      {:jiffy_ex, "~> 1.1"},
      {:elixir_uuid, "~> 1.2"}
    ]
  end
end
