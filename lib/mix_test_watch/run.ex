defmodule MixTestWatch.Run do
  @moduledoc """
  Runs tests according to given path
  """

  alias MixTestWatch.Command
  alias MixTestWatch.Files
  alias MixTestWatch.Shell

  @spec run(String.t, String.t) :: :ok

  def run(path, config) do
    case run_single( path, config ) do
      :ok      -> run_tests( config )   # single test found and successful
      :no_test -> run_tests( config )   # single test not found
      _        -> true                  # single test found but unsuccessful
    end
  end

  @spec run_tests(String.t) :: :ok

  def run_tests(config) do
    config |> Command.build |> Shell.exec
  end

  @spec run_single(String.t, String.t) :: :ok

  defp run_single(path, config) do
    if test_file?(path) do
      run_tests %{config | cli_args: config.cli_args <> " " <> path}
    else
      case Files.find_test(path) do
        nil   ->
          IO.puts "\nIgnoring #{path}"
          :no_test
        found ->
          run_single(found, config)
      end
    end
  end

  @spec test_file?(String.t) :: boolean

  defp test_file?(path) do
    pwd    = Path.absname("./")
    path
      |> Path.relative_to(pwd)
      |> String.starts_with?("test/")
  end

end
