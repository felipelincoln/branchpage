defmodule Web.MixProject do
  use Mix.Project

  def project do
    [
      app: :web,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.11",
      compilers: [:phoenix] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {Web.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp deps do
    [
      {:phoenix, "~> 1.5.8"},
      {:phoenix_html, "~> 2.14"},
      {:phoenix_live_view, "~> 0.15.4"},
      {:phoenix_live_reload, "~> 1.3"},
      {:plug_cowboy, "~> 2.0"},
      {:jason, "~> 1.2"},
      {:timex, "~> 3.0"}
    ]
  end
end
