defmodule MixTestWatch.Config do
  @moduledoc """
  Responsible for gathering and packaging the configuration for the task.
  """

  @default_runner MixTestWatch.HotRunner
  @default_tasks ~w(test)
  @default_clear false
  @default_exclude []
  @default_extra_extensions []

  defstruct tasks:            @default_tasks,
            clear:            @default_clear,
            runner:           @default_runner,
            exclude:          @default_exclude,
            extra_extensions: @default_extra_extensions,
            cli_args:         []


  @spec new([String.t]) :: %__MODULE__{}
  @doc """
  Create a new config struct, taking values from the ENV
  """
  def new(cli_args \\ []) do
    %__MODULE__{
      tasks:             get_tasks(),
      clear:             get_clear(),
      runner:            get_runner(),
      exclude:           get_excluded(),
      cli_args:          cli_args,
      extra_extensions:  get_extra_extensions(),
    }
  end


  defp get_runner do
    Application.get_env(:mix_test_watch, :runner, @default_runner)
  end

  defp get_tasks do
    Application.get_env(:mix_test_watch, :tasks, @default_tasks)
  end

  defp get_clear do
    Application.get_env(:mix_test_watch, :clear, @default_clear)
  end

  defp get_excluded do
    Application.get_env(:mix_test_watch, :exclude, @default_exclude)
  end

  defp get_extra_extensions do
    Application.get_env(:mix_test_watch, :extra_extensions,
      @default_extra_extensions)
  end
end
