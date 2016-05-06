defmodule MixTestWatch.Watcher do
  use GenServer

  alias MixTestWatch.CompileTask
  alias MixTestWatch.Config
  alias MixTestWatch.GenTask
  alias MixTestWatch.Message
  alias MixTestWatch.Path, as: MPath
  alias MixTestWatch.TestTask

  @moduledoc """
  A server that runs tests whenever source files change.
  """

  # Client API

  def start(%Config{} = config) do
    GenServer.start(__MODULE__, config, name: __MODULE__)
  end

  def start_link(%Config{} = config \\ %Config{}) do
    GenServer.start_link(__MODULE__, config, name: __MODULE__)
  end

  def run_tasks do
    GenServer.cast(__MODULE__, :run_tasks)
  end


  # Genserver callbacks

  @spec init(String.t) :: {:ok, %{ args: String.t}}

  def init(config) do
    :ok = :fs.subscribe
    {:ok, config}
  end

  def handle_cast(:run_tasks, config) do
    run_tasks(config)
    {:noreply, config}
  end

  def handle_info({_pid, {:fs, :file_event}, {path, _event}}, config) do
    path = to_string(path)
    if MPath.watching?(path) and not MPath.excluded?(config, path) do
      run_tasks( config )
    end
    {:noreply, config}
  end


  # Internal functions

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
