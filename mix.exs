defmodule BranchPage.Umbrella.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      preferred_cli_env: [
        ci: :test,
        coveralls: :test,
        "coveralls.html": :test,
        "ecto.reset.test": :test
      ],
      test_coverage: [tool: ExCoveralls],
      deps: deps(),
      aliases: aliases(),
      releases: releases()
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:excoveralls, "== 0.13.3", only: [:dev, :test]}
    ]
  end

  defp aliases do
    [
      "ecto.reset.test": ["ecto.reset"],
      "ecto.reset": ["ecto.drop", "ecto.create", "ecto.migrate"],
      ci: ["format --check-formatted", "credo --strict", "test"]
    ]
  end

  defp releases do
    [
      web: [applications: [web: :permanent]]
    ]
  end
end
