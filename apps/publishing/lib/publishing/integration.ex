defmodule Publishing.Integration do
  @moduledoc """
  Integration
  """

  alias Publishing.Integration.Github

  def service(url) do
    case URI.parse(url) do
      %URI{host: "github.com"} -> {:ok, Github}
      _ -> {:error, :integration}
    end
  end
end
