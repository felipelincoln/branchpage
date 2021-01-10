defmodule BranchPage.MixProject do
  use Mix.Project

  # `Mix.env` is set to be `:app` to prevent recompiling when
  # running the application in different environments. The
  # value of `MIX_ENV` is still being used, but it is obtained
  # through `System.get_env/1`.
  Mix.env(:app)

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: System.get_env("MIX_ENV") == :prod,
      deps: deps()
    ]
  end

  defp deps do
    []
  end
end
