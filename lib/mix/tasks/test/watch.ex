defmodule Mix.Tasks.Test.Watch do
  use Mix.Task
  use GenServer

  alias MixTestWatch, as: M

  @shortdoc """
  Automatically run tests on file changes
  """
  @moduledoc """
  A task for running tests whenever source files change.
  """

  @spec run([String.t]) :: no_return

  def run(args) do
    args     = Enum.join(args, " ")
    :ok      = Application.start :fs, :permanent
    {:ok, _} = GenServer.start_link( __MODULE__, args, name: __MODULE__ )
    run_tests(args)
    :timer.sleep :infinity
  end


  # Genserver callbacks

  @spec init(String.t) :: {:ok, %{ args: String.t}}

  def init(args) do
    :ok = :fs.subscribe
    {:ok, %{ args: args }}
  end

  @type fs_path    :: char_list
  @type fs_event   :: {:fs, :file_event}
  @type fs_details :: {fs_path, any}
  @spec handle_info({pid, fs_event, fs_details}, %{}) :: {:noreply, %{}}

  def handle_info({_pid, {:fs, :file_event}, {path, _event}}, state) do
    if M.Path.watching?( to_string path ) do
      run_tests( state.args )
    end
    {:noreply, state}
  end


  @spec run_tests(String.t) :: :ok

  defp run_tests(args) do
    IO.puts "\nRunning tests..."
    :ok = args |> M.Command.build |> M.Command.exec
    flush
    :ok
  end

  @spec flush :: :ok

  defp flush do
    receive do
      _       -> flush
      after 0 -> :ok
    end
  end
end
