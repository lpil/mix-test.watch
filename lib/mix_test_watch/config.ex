defmodule MixTestWatch.Config do
  @moduledoc """
  Responsible for gathering and packaging the configuration for the task.
  """

  @default_tasks ~w(test)
  @default_prefix "mix"
  @default_clear false

  defstruct tasks:    @default_tasks,
            prefix:   @default_prefix,
            clear:    @default_clear,
            cli_args: ""


  @spec new([String.t]) :: %__MODULE__{}
  @doc """
  Create a new config struct, taking values from the ENV
  """
  def new(cli_args \\ []) do
    args = Enum.join(cli_args, " ")
    %__MODULE__{
      tasks:    get_tasks(),
      prefix:   get_prefix(),
      clear:    get_clear(),
      cli_args: args,
    }
  end


  defp get_tasks do
    Application.get_env(:mix_test_watch, :tasks, @default_tasks)
  end

  defp get_prefix do
    Application.get_env(:mix_test_watch, :prefix, @default_prefix)
  end

  defp get_clear do
    Application.get_env(:mix_test_watch, :clear, @default_clear)
  end
end
