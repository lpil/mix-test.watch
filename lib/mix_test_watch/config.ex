defmodule MixTestWatch.Config do
  @moduledoc """
  Responsible for gathering and packaging the configuration for the task.
  """

  @default_runner MixTestWatch.PortRunner
  @default_tasks ~w(test)
  @default_clear false
  @default_timestamp false
  @default_exclude [~r/\.#/, ~r{priv/repo/migrations}]
  @default_extra_extensions []
  @default_cli_executable "mix"

  defstruct tasks: @default_tasks,
            clear: @default_clear,
            timestamp: @default_timestamp,
            runner: @default_runner,
            exclude: @default_exclude,
            extra_extensions: @default_extra_extensions,
            cli_executable: @default_cli_executable,
            cli_args: []

  @spec new([String.t()]) :: %__MODULE__{}
  @doc """
  Create a new config struct, taking values from the ENV
  """
  def new(cli_args \\ []) do
    %__MODULE__{
      tasks: get_config(:tasks, @default_tasks),
      clear: get_config(:clear, @default_clear),
      timestamp: get_config(:timestamp, @default_timestamp),
      runner: get_config(:runner, @default_runner),
      exclude: get_config(:exclude, @default_exclude),
      cli_executable: get_config(:cli_executable, @default_cli_executable),
      cli_args: cli_args,
      extra_extensions: get_config(:extra_extensions, @default_extra_extensions)
    }
  end

  defp get_config(key, default), do: Application.get_env(:mix_test_watch, key, default)
end
