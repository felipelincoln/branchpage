defmodule Publishing.Factory do
  @moduledoc """
  Module for teste data fabrication
  """

  use ExMachina.Ecto, repo: Publishing.Repo

  alias Publishing.Interact.DailyImpressionCounter
  alias Publishing.Manage.{Article, Blog, Platform}

  def article_factory, do: %Article{}
  def blog_factory, do: %Blog{}
  def platform_factory, do: %Platform{}
  def daily_impression_counter_factory, do: %DailyImpressionCounter{}
end
