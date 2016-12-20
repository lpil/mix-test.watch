#
# Do you know how we could test this task? If so, get in touch :)
#
defmodule MixTestWatch.CompileTask do
  @moduledoc """
  Run the compile task, even if it has been run before.
  """

  tasks = ~w(compile compile.all compile.protocols loadpaths deps.loadpaths)
  dep_tasks =
    Mix.Tasks.Compile.compilers()
    |> Enum.reduce(tasks, fn(x, acc) -> ["compile.#{x}" | acc] end)

  @dep_tasks dep_tasks

  def run do
    Enum.each(@dep_tasks, &Mix.Task.reenable/1)
    Mix.Task.run("compile", [])
  end
end
