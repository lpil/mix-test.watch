defmodule MixTestWatch.CompileTask do
  @moduledoc """
  Run the compile task, even if it has been run before.
  """

  def run do
    Enum.each(dep_tasks, &Mix.Task.reenable/1)
    Mix.Task.run("compile", [])
  end

  def dep_tasks do
    tasks = ~w(compile compile.all compile.protocols loadpaths deps.loadpaths)
    Mix.Tasks.Compile.compilers()
    |> Enum.reduce(tasks, fn(x, acc)-> ["compile.#{x}"|acc] end)
  end
end
