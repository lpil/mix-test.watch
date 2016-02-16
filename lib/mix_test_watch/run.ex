defmodule MixTestWatch.Run do
  @moduledoc """
  Runs tests according to given path
  """

  alias MixTestWatch.Command
  alias MixTestWatch.Files
  alias MixTestWatch.Shell

  @spec run(String.t, String.t) :: :ok

  def run(path, config) do
    path
    |> Files.find_test
    |> case do
      :none       -> run_all(config)
      {:ok, one } -> run_one(one, config)
    end
    |> case do
      {:one, :ok} -> run_all(config)
      {_, res}    -> res
    end
  end

  @spec run_tests(String.t) :: :ok

  def run_tests(config) do
    config |> Command.build |> Shell.exec
  end

  @spec run_one(String.t, String.t) :: :ok

  defp run_one(path, config) do
    {:one, run_tests %{config | cli_args: config.cli_args <> " " <> path}}
  end

  @spec run_all(String.t) :: :ok

  def run_all(config) do
    {:all, run_tests(config) }
  end

end
