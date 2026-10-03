defmodule MixTestWatch.Config do
  @moduledoc """
  Responsible for gathering and packaging the configuration for the task.
  """

  @default_runner MixTestWatch.PortRunner
  @default_tasks ~w(test)
  @default_clear false
  @default_timestamp false
  @default_exclude ["""\\\.#""", "priv/repo/migrations"]
  @default_extra_extensions []
  @default_cli_executable ~s(elixir --erl "-elixir ansi_enabled true" -S mix)
  @default_terminate_before_run false

  defstruct tasks: @default_tasks,
            clear: @default_clear,
            timestamp: @default_timestamp,
            runner: @default_runner,
            exclude: @default_exclude,
            extra_extensions: @default_extra_extensions,
            cli_executable: @default_cli_executable,
            cli_args: [],
            terminate_before_run: @default_terminate_before_run

  @type t :: %__MODULE__{
          tasks: [String.t()],
          clear: boolean(),
          timestamp: boolean(),
          runner: atom(),
          exclude: [String.t()],
          extra_extensions: [String.t()],
          cli_executable: String.t(),
          cli_args: [String.t()],
          terminate_before_run: boolean()
        }

  @spec new([String.t()]) :: t()
  @doc """
  Create a new config struct, taking values from the ENV
  """
  def new(cli_args \\\\ []) do
    %__MODULE__{
      tasks: get_tasks(cli_args),
      clear: get_clear(cli_args),
      timestamp: get_timestamp(cli_args),
      runner: get_runner(),
      exclude: get_excluded(),
      extra_extensions: get_extra_extensions(),
      cli_executable: get_cli_executable(),
      cli_args: cli_args,
      terminate_before_run: get_terminate_before_run(cli_args)
    }
  end

  defp get_runner do
    Application.get_env(:mix_test_watch, :runner, @default_runner)
  end

  defp get_tasks(cli_args) do
    if "--terminate-before-run" in cli_args do
      @default_tasks
    else
      Application.get_env(:mix_test_watch, :tasks, @default_tasks)
    end
  end

  defp get_clear(cli_args) do
    if "--no-clear" in cli_args do
      false
    else
      Application.get_env(:mix_test_watch, :clear, @default_clear)
    end
  end

  defp get_timestamp(cli_args) do
    if "--no-timestamp" in cli_args do
      false
    else
      Application.get_env(:mix_test_watch, :timestamp, @default_timestamp)
    end
  end

  defp get_excluded do
    Application.get_env(:mix_test_watch, :exclude, @default_exclude)
    |> Enum.map(fn
      pattern when is_binary(pattern) -> Regex.compile!(pattern)
      pattern = %Regex{} -> pattern
    end)
  end

  defp get_cli_executable do
    Application.get_env(:mix_test_watch, :cli_executable, @default_cli_executable)
  end

  defp get_extra_extensions do
    Application.get_env(:mix_test_watch, :extra_extensions, @default_extra_extensions)
  end

  defp get_terminate_before_run(cli_args) do
    if "--terminate-before-run" in cli_args do
      true
    else
      Application.get_env(:mix_test_watch, :terminate_before_run, @default_terminate_before_run)
    end
  end
end
