defmodule Publishing.PageNotFound do
  defexception message: "Page not found."

  defimpl Plug.Exception, for: __MODULE__ do
    def status(_), do: 404
    def actions(_), do: []
  end
end
