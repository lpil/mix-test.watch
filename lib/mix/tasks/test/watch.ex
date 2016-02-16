defmodule Mix.Tasks.Test.Watch do
  use Mix.Task
  use GenServer

  alias MixTestWatch.Path, as: MPath
  alias MixTestWatch.Shell
  alias MixTestWatch.Config
  alias MixTestWatch.Run

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
    Run.run_tests(config)
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
    path = to_string path
    if MPath.watching?(path) do
      Run.run(path, config)
      flush
    end
    {:noreply, config}
  end


  @spec flush :: :ok

  defp flush do
    receive do
      _       -> flush
      after 0 -> :ok
    end
  end

end
