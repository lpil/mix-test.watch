defmodule Mix.Tasks.Test.Watch do
  use Mix.Task

  @shortdoc """
  Automatically run tests on file changes
  """
  @moduledoc """
  A task for running tests whenever source files change.
  """

  defdelegate run(args), to: MixTestWatch
end
