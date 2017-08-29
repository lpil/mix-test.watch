defmodule MixTestWatch do
  @moduledoc """
  Automatically run your Elixir project's tests each time you save a file.
  Because TDD is awesome.
  """

  use Application
  alias MixTestWatch.Watcher

  #
  # Public interface
  #

  @spec run([String.t]) :: no_return
  def run(args \\ []) when is_list(args) do
    Mix.env :test
    put_config(args)
    :ok = Application.ensure_started(:fs)
    :ok = Application.ensure_started(:mix_test_watch)
    Watcher.run_setup_tasks
    Watcher.run_tasks
    no_halt_unless_in_repl()
  end


  #
  # Application callback
  #

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    children = [
      worker(Watcher, []),
    ]
    opts = [strategy: :one_for_one, name: Sup.Supervisor]
    Supervisor.start_link(children, opts)
  end


  #
  # Internal functions
  #

  defp put_config(args) do
    config = MixTestWatch.Config.new(args)
    Application.put_env(:mix_test_watch, :__config__, config, persistent: true)
  end

  defp no_halt_unless_in_repl do
    unless Code.ensure_loaded?(IEx) && IEx.started? do
      :timer.sleep :infinity
    end
  end
end
