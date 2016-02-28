defmodule Mix.Tasks.Test.Watch do
  use Mix.Task
  use GenServer

  alias MixTestWatch.Command
  alias MixTestWatch.Message
  alias MixTestWatch.Path, as: MPath
  alias MixTestWatch.Shell
  alias MixTestWatch.Config

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
    run_tests(config)
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
    if MPath.watching?( to_string path ) do
      run_tests( config )
    end
    {:noreply, config}
  end


  @spec run_tests(String.t) :: :ok

  defp run_tests(config) do
    maybe_clear(config)
    IO.puts "\nRunning tests..."
    :ok = config |> Command.build |> Shell.exec
    Message.flush
    :ok
  end

  defp maybe_clear(%{clear: false}), do: nil
  defp maybe_clear(%{clear: true}), do: IO.puts IO.ANSI.clear

end
