defmodule Mix.Tasks.Feed do
  use Mix.Task

  @shortdoc "This is short documentation, see"

  @moduledoc """
  A test task.
  """
  def run(_) do
    Lunchfund.main()
  end
end
