defmodule MixTestWatch.Config do
  @moduledoc """
  Responsible for gathering and packaging the configuration for the task.
  """

  @default_tasks ~w(test)
  @default_prefix "mix"

  defstruct tasks:    @default_tasks,
            prefix:   @default_prefix,
            cli_args: "",
            quiet:    Mix.env == :dev


  @spec new([String.t]) :: %__MODULE__{}
  @doc """
  Create a new config struct, taking values from the ENV
  """
  def new(cli_args \\ []) do
    args = Enum.join(cli_args, " ")
    %__MODULE__{
      tasks:    get_tasks(),
      prefix:   get_prefix(),
      cli_args: args,
    }
  end


  defp get_tasks do
    Application.get_env(:mix_test_watch, :tasks, @default_tasks)
  end

  defp get_prefix do
    Application.get_env(:mix_test_watch, :prefix, @default_prefix)
  end
end
