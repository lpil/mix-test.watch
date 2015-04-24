defmodule Mix.Tasks.Test.Watch do
  use Mix.Task
  use GenServer

  def run(_) do
    set_mix_env!
    Application.start :fs
    GenServer.start_link( __MODULE__, [], name: __MODULE__ )
    :timer.sleep :infinity
  end


  def init(_) do
    :fs.subscribe
    {:ok, []}
  end

  def handle_info({_pid, {:fs, :file_event}, {path, _event}}, _) do
    path = to_string path
    if watching? path do run_tests end
    {:noreply, []}
  end


  def watching?(path) do
    Regex.match?( ~r/\.exs?\z/i, path )
  end

  def run_tests do
    # Mix.Tasks.Test.run []
    {output, _} = System.cmd "mix", ["test"]
    IO.puts "\n\n" <> output
  end

  def set_mix_env! do
    unless System.get_env "MIX_ENV" do
      System.put_env( "MIX_ENV", "test" )
    end
  end
end
