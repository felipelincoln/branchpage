defmodule Publishing.Factory do
  @moduledoc """
  Module for teste data fabrication
  """

  use ExMachina.Ecto, repo: Publishing.Repo

  alias Publishing.{Article, Blog}

  def article_factory, do: %Article{}

  def blog_factory, do: %Blog{}
end
