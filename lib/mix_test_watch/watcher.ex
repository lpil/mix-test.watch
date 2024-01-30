defmodule MixTestWatch.Watcher do
  use GenServer

  alias MixTestWatch, as: MTW
  alias MixTestWatch.Config

  require Logger

  @moduledoc """
  A server that runs tests whenever source files change.
  """

  #
  # Client API
  #

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def run_tasks do
    GenServer.cast(__MODULE__, :run_tasks)
  end

  #
  # Genserver callbacks
  #

  @spec init(String.t()) :: {:ok, Task.t()}

  def init(_) do
    opts = [dirs: [Path.absname("")], name: :mix_test_watcher]

    case FileSystem.start_link(opts) do
      {:ok, _} ->
        FileSystem.subscribe(:mix_test_watcher)
        {:ok, Task.completed(:ok)}

      other ->
        Logger.warning("Could not start the file system monitor.")
        other
    end
  end

  def handle_cast(:run_tasks, prev) do
    config = get_config()

    Logger.info("Received :run_tasks message, restarting tasks...")
    next = respawn(prev, config)

    {:noreply, next}
  end

  def handle_info({:file_event, _, {path, _events}}, prev) do
    config = get_config()
    path = to_string(path)

    next =
      if MTW.Path.watching?(path, config) do
        Logger.info("File #{path}")
        Logger.info("Received :file_event message, restarting tasks...")
        next = respawn(prev, config)
        MTW.MessageInbox.flush()
        next
      else
        prev
      end

    {:noreply, next}
  end

  def handle_info({ref, _}, state) when is_reference(ref) do
    {:noreply, state}
  end

  def handle_info({:DOWN, ref, :process, _, _}, state) when is_reference(ref) do
    {:noreply, state}
  end

  #
  # Internal functions
  #

  @spec get_config() :: %Config{}

  defp get_config do
    Application.get_env(:mix_test_watch, :__config__, %Config{})
  end

  @spec respawn(Task.t(), %Config{}) :: Task.t()
  defp respawn(prev, config) do
    Task.shutdown(prev, :brutal_kill)
    Task.async(fn -> MTW.Runner.run(config) end)
  end
end
