defmodule MixTestWatch do
  @moduledoc """
  Automatically run your Elixir project's tests each time you save a file.
  Because TDD is awesome.
  """

  use Application
  alias MixTestWatch.Watcher

  @spec run([String.t]) :: no_return


  def run(args \\ []) when is_list(args) do
    _ = args # TODO: Inject config
    :ok = Application.ensure_started(:fs)
    :ok = Application.ensure_started(:mix_test_watch)
    Watcher.run_tasks
    no_halt_unless_in_repl()
  end

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    children = [
      worker(Watcher, []),
    ]
    opts = [strategy: :one_for_one, name: Sup.Supervisor]
    Supervisor.start_link(children, opts)
  end


  defp no_halt_unless_in_repl do
    unless Code.ensure_loaded?(IEx) && IEx.started? do
      :timer.sleep :infinity
    end
  end
end
