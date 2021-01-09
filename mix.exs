defmodule BranchPage.MixProject do
  use Mix.Project

  Mix.env(:app)

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: System.get_env("MIX_ENV") == :prod,
      deps: deps()
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    []
  end
end
