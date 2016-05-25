defmodule MixTestWatch.Config do
  @moduledoc """
  Responsible for gathering and packaging the configuration for the task.
  """

  @default_tasks ~w(test)
  @default_clear false
  @default_exclude []
  @default_include []

  defstruct tasks:    @default_tasks,
            clear:    @default_clear,
            exclude:  @default_exclude,
            include:  @default_include,
            cli_args: []


  @spec new([String.t]) :: %__MODULE__{}
  @doc """
  Create a new config struct, taking values from the ENV
  """
  def new(cli_args \\ []) do
    %__MODULE__{
      tasks:    get_tasks(),
      clear:    get_clear(),
      include:  get_included(),
      exclude:  get_excluded(),
      cli_args: cli_args,
    }
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

  defp get_included do
    Application.get_env(:mix_test_watch, :include, @default_include)
  end
end
