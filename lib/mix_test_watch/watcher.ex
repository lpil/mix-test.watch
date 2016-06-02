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

  def start do
    GenServer.start(__MODULE__, [], name: __MODULE__)
  end

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def run_tasks do
    GenServer.cast(__MODULE__, :run_tasks)
  end


  # Genserver callbacks

  @spec init(String.t) :: {:ok, %{ args: String.t}}

  def init(_) do
    :ok = :fs.subscribe
    {:ok, []}
  end

  def handle_cast(:run_tasks, state) do
    config = get_config()
    do_run_tasks(config)
    {:noreply, state}
  end

  def handle_info({_pid, {:fs, :file_event}, {path, _event}}, state) do
    config = get_config()
    path   = to_string(path)
    if MPath.watching?(config, path) and not MPath.excluded?(config, path) do
      do_run_tasks( config )
    end
    {:noreply, state}
  end


  # Internal functions

  @spec get_config() :: %Config{}

  defp get_config do
    Application.get_env(:mix_test_watch, :__config__, %Config{})
  end

  @spec do_run_tasks(String.t) :: :ok

  defp do_run_tasks(config) do
    maybe_clear(config)
    IO.puts "\nRunning tests..."
    CompileTask.run
    config.tasks |> Enum.each(&do_run_task(&1, config.cli_args))
    Message.flush
    :ok
  end

  defp do_run_task("test", args) do
    TestTask.run(args)
  end
  defp do_run_task(task, args) do
    GenTask.run(task, args)
  end

  defp maybe_clear(%{clear: false}), do: nil
  defp maybe_clear(%{clear: true}), do: IO.puts IO.ANSI.clear
end
