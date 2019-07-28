defmodule UltronX.MixProject do
  use Mix.Project

  def project do
    [
      app: :ultronx,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript()
    ]
  end

  def escript do
    [main_module: UltronApp]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {UltronApp, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      {:slack, "0.19.0"},
      {:tesla, "~> 1.2.1"},
      {:poison, "~> 3.1"},
      {:new_relic_agent, "~> 1.0"},
      {:dialyxir, "~> 0.4", only: [:dev]}
    ]
  end
end
