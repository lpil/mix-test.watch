defmodule Mix.Tasks.Test.Watch do
  use Mix.Task
  use GenServer

  alias MixTestWatch.CompileTask
  alias MixTestWatch.Config
  alias MixTestWatch.GenTask
  alias MixTestWatch.Message
  alias MixTestWatch.Path, as: MPath
  alias MixTestWatch.TestTask

  @shortdoc """
  Automatically run tests on file changes
  """
  @moduledoc """
  A task for running tests whenever source files change.
  """

  @spec run([String.t]) :: no_return

  def run(args) do
    config = Config.new(args)
    :ok      = Application.start :fs, :permanent
    {:ok, _} = GenServer.start_link( __MODULE__, config, name: __MODULE__ )
    run_tasks(config)
    :timer.sleep :infinity
  end


  # Genserver callbacks

  @spec init(String.t) :: {:ok, %{ args: String.t}}

  def init(config) do
    :ok = :fs.subscribe
    {:ok, config}
  end

  @type fs_path    :: char_list
  @type fs_event   :: {:fs, :file_event}
  @type fs_details :: {fs_path, any}
  @spec handle_info({pid, fs_event, fs_details}, %{}) :: {:noreply, %{}}

  def handle_info({_pid, {:fs, :file_event}, {path, _event}}, config) do
    path = to_string(path)
    if MPath.watching?(path) and not MPath.excluded?(config, path) do
      run_tasks( config )
    end
    {:noreply, config}
  end


  @spec run_tasks(String.t) :: :ok

  defp run_tasks(config) do
    maybe_clear(config)
    IO.puts "\nRunning tests..."
    CompileTask.run
    config.tasks |> Enum.each(&run_task(&1, config.cli_args))
    Message.flush
    :ok
  end

  defp run_task("test", args) do
    TestTask.run(args)
  end
  defp run_task(task, args) do
    GenTask.run(task, args)
  end

  defp maybe_clear(%{clear: false}), do: nil
  defp maybe_clear(%{clear: true}), do: IO.puts IO.ANSI.clear
end
