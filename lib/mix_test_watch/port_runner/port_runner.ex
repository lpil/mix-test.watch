defmodule MixTestWatch.PortRunner do
  @moduledoc """
  Run the tasks in a new OS process via ports
  """

  alias MixTestWatch.Config

  @doc """
  Run tests using the runner from the config.
  """
  def run(%Config{} = config) do
    command = build_tasks_cmds(config)

    case :os.type() do
      {:win32, _} ->
        System.cmd("cmd", ["/C", "set MIX_ENV=test&& mix test"], into: IO.stream(:stdio, :line))

      _ ->
        terminator = Path.join(:code.priv_dir(:mix_test_watch), "zombie_killer")

        final_cmd =
          if config.terminate_before_run do
            terminate_command() <> " && " <> command
          else
            command
          end

        terminator
        |> System.cmd(["sh", "-c", final_cmd], into: IO.stream(:stdio, :line))
    end

    :ok
  end

  @doc """
  Build a shell command that runs the desired mix task(s).

  Colour is forced on- normally Elixir would not print ANSI colours while
  running inside a port.
  """
  def build_tasks_cmds(config = %Config{}) do
    config.tasks
    |> Enum.map(&task_command(&1, config))
    |> Enum.join(" && ")
  end

  @doc """
  Generate a SQL command to terminate backend connections for the test database.

  This is used when `--terminate-before-run` is set, to kill stale Ecto
  Sandbox connections (pool_size: N) that prevent the test database from
  being dropped between test runs (fixes #114).

  The command is injected as a `psql` invocation before the test command runs.
  It reads the DB name from `DATABASE_URL` or falls back to the default
  `*test` name.
  """
  def terminate_command do
    """
    PGPASSWORD=\${PGPASSWORD:-} psql -U \${DB_USER:-postgres} \
      -h \${DB_HOST:-localhost} -d \${DB_NAME:-myapp_test} \
      -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity \
      WHERE datname = '\${DB_NAME:-myapp_test}' \
        AND pid <> pg_backend_pid() \
        AND state = 'idle';" 2>/dev/null || true;
    """
  end

  defp task_command(task, config) do
    args = Enum.join(config.cli_args, " ")

    ansi =
      case Enum.member?(config.cli_args, "--no-start") do
        true -> "run --no-start -e 'Application.put_env(:elixir, :ansi_enabled, true);'"
        false -> "run -e 'Application.put_env(:elixir, :ansi_enabled, true);'"
      end

    [config.cli_executable, "do", ansi <> " +", task, args]
    |> Enum.filter(& &1)
    |> Enum.join(" ")
    |> (fn command -> "MIX_ENV=test #{command}" end).()
    |> String.trim()
  end
end
