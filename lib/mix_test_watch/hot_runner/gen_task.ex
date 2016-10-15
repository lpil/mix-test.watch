defmodule MixTestWatch.GenTask do
  @moduledoc """
  Runs a mix task, even if it has been run before.
  """
  def run(task, args \\ [])
  when is_binary(task)
  and is_list(args)
  do
    Mix.Task.reenable(task)
    Mix.Task.run(task, args)
  end
end
