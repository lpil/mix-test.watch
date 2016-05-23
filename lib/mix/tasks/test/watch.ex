defmodule Mix.Tasks.Test.Watch do
  use Mix.Task

  @moduledoc """
  A task for running tests whenever source files change.
  """
  @shortdoc "Automatically run tests on file changes"
  @preferred_cli_env :test

  defdelegate run(args), to: MixTestWatch
end
