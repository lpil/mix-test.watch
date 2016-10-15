defmodule MixTestWatch.HotRunner do
  @moduledoc """
  Run the tasks in the current VM process.

  Still needs work.
  """

  alias MixTestWatch, as: MTW
  alias MixTestWatch.Config

  @doc """
  Run tests using the runner from the config.
  """
  def run(%Config{} = config) do
    MTW.CompileTask.run
    config.tasks |> Enum.each(&run_task(&1, config.cli_args))
    :ok
  end


  #
  # Internal functions
  #

  defp run_task("test", args) do
    MTW.TestTask.run(args)
  end
  defp run_task(task, args) do
    MTW.GenTask.run(task, args)
  end
end
