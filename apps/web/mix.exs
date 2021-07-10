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
      test_coverage: [tool: ExCoveralls],
      deps: deps()
    ]
  end

  def application do
    [
      mod: {Web.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:publishing, in_umbrella: true},
      {:phoenix, "~> 1.5.8"},
      {:phoenix_html, "~> 2.14"},
      {:phoenix_live_view, "~> 0.15.4"},
      {:phoenix_live_reload, "~> 1.3", only: :dev},
      {:plug_cowboy, "~> 2.0"},
      {:jason, "~> 1.2"},
      {:ueberauth, "~> 0.6"},
      {:ueberauth_github, "~> 0.7"}
    ]
  end
end
