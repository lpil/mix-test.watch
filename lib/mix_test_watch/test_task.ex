defmodule MixTestWatch.TestTask do
  @moduledoc """
  Runs the `test` mix task, even if it has been run before.
  """
  def run(args) do
    Mix.env(:test)
    unload_test_files()
    reenable_dependancy_tasks()
    Mix.Task.run("test", args)
    cleanup_memory()
  end

  defp test_paths do
    Mix.Project.config[:test_paths] || ["test"]
  end

  defp unload_test_files do
    test_files =
      test_paths
      |> Mix.Utils.extract_files("*")
      |> Enum.map(&Path.expand/1)
    :elixir_code_server.cast({:unload_files, test_files})
  end

  defp reenable_dependancy_tasks do
    ~w(loadpaths deps.loadpaths test)
    |> Enum.map(&Mix.Task.reenable/1)
  end

  def cleanup_memory do
    :elixir_config.put(:at_exit, [])
  end
end
