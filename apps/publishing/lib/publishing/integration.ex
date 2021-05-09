defmodule Publishing.Integration do
  @moduledoc """
  Integrations modules extract information from code hosting platforms.
  """

  alias Publishing.Integration.Github

  @callback get_content(String.t()) :: {:ok, String.t()} | {:error, integer}
  @callback get_username(String.t()) :: {:ok, String.t() | {:error, :username}}
  @callback content_heading(String.t()) :: String.t()

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
