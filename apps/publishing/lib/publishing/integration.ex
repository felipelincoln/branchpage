defmodule Publishing.Integration do
  @moduledoc """
  Integration
  """

  alias Publishing.Integration.Github

  @doc """
  Returns the `url`'s integration module.

  ## Currently supported integrations
  * Github: `Publishing.Integration.Github`

  Examples:
      iex> service("https://github.com/teste")
      {:ok, Publishing.Integration.Github}

      iex> service("https://gitlab.com/teste")
      {:error, :integration}
  """
  @spec service(String.t()) :: {:ok, module} | {:error, :integration}
  def service(url) do
    case URI.parse(url) do
      %URI{host: "github.com"} -> {:ok, Github}
      _ -> {:error, :integration}
    end
  end
end
