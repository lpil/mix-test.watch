defmodule MixTestWatch.Config do
  @moduledoc """
  Responsible for gathering and packaging the configuration for the task.
  """

  @default_runner MixTestWatch.PortRunner
  @default_setup_tasks ~w()
  @default_tasks ~w(test)
  @default_clear false
  @default_timestamp false
  @default_exclude []
  @default_extra_extensions []
  @default_cli_executable "mix"


  defstruct setup_tasks:      @default_setup_tasks,
            tasks:            @default_tasks,
            clear:            @default_clear,
            timestamp:        @default_timestamp,
            runner:           @default_runner,
            exclude:          @default_exclude,
            extra_extensions: @default_extra_extensions,
            cli_executable:   @default_cli_executable,
            cli_args:         []

  @spec new([String.t]) :: %__MODULE__{}
  @doc """
  Create a new config struct, taking values from the ENV
  """
  def new(cli_args \\ []) do
    %__MODULE__{
      setup_tasks:       get_setup_tasks(),
      tasks:             get_tasks(),
      clear:             get_clear(),
      timestamp:         get_timestamp(),
      runner:            get_runner(),
      exclude:           get_excluded(),
      cli_executable:    get_cli_executable(),
      cli_args:          cli_args,
      extra_extensions:  get_extra_extensions(),
    }
  end


  defp get_runner do
    Application.get_env(:mix_test_watch, :runner, @default_runner)
  end

  defp get_setup_tasks do
    Application.get_env(:mix_test_watch, :setup_tasks, @default_setup_tasks)
  end

  defp get_tasks do
    Application.get_env(:mix_test_watch, :tasks, @default_tasks)
  end

  defp get_clear do
    Application.get_env(:mix_test_watch, :clear, @default_clear)
  end

  defp get_timestamp do
    Application.get_env(:mix_test_watch, :timestamp, @default_timestamp)
  end

  defp get_excluded do
    Application.get_env(:mix_test_watch, :exclude, @default_exclude)
  end

  defp get_cli_executable do
    Application.get_env(:mix_test_watch, :cli_executable,
                        @default_cli_executable)
  end

  defp get_extra_extensions do
    Application.get_env(:mix_test_watch, :extra_extensions,
                        @default_extra_extensions)
  end
end
