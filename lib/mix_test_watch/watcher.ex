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

  @spec init(String.t()) :: {:ok, %{args: String.t()}}

  def init(_) do
    opts = [dirs: [Path.absname("")], name: :mix_test_watcher]
    case FileSystem.start_link(opts) do
      {:ok, _} ->
        FileSystem.subscribe(:mix_test_watcher)
        {:ok, []}
      other ->
        Logger.warn """
        Could not start the file system monitor.
        """
        other
    end
  end

  def handle_cast(:run_tasks, state) do
    config = get_config()
    MTW.Runner.run(config)
    {:noreply, state}
  end

  def handle_info({:file_event, _, {path, _events}}, state) do
    config = get_config()
    path = to_string(path)

    if MTW.Path.watching?(path, config) do
      MTW.Runner.run(config)
      MTW.MessageInbox.flush()
    end

    {:noreply, state}
  end

  #
  # Internal functions
  #

  @spec get_config() :: %Config{}

  defp get_config do
    Application.get_env(:mix_test_watch, :__config__, %Config{})
  end
end
