defmodule MixTestWatch.PortRunnerTest do
  use ExUnit.Case, async: true

  alias MixTestWatch.PortRunner
  alias MixTestWatch.Config

  describe "build_tasks_cmds/1" do
    test "appends commandline arguments from passed config" do
      config = %Config{cli_args: ["--exclude", "integration"]}

      expected =
        "MIX_ENV=test mix do run -e " <>
          "'Application.put_env(:elixir, :ansi_enabled, true);', " <> "test --exclude integration"

      assert PortRunner.build_tasks_cmds(config) == expected
    end

    test "ignores cli_args if task has :ignore_cli_args in definition" do
      config = %Config{
        cli_args: ["--exclude", "integration"],
        tasks: [{"test", :ignore_cli_args}]
      }

      expected =
        "MIX_ENV=test mix do run -e " <>
          "'Application.put_env(:elixir, :ansi_enabled, true);', " <> "test"

      assert PortRunner.build_tasks_cmds(config) == expected
    end

    test "ignores cli_args for with specific key in task" do
      config = %Config{
        cli_args: ["--exclude", "integration"],
        tasks: ["test", {"credo", :ignore_cli_args}]
      }

      first_task_expected =
        "MIX_ENV=test mix do run -e " <>
          "'Application.put_env(:elixir, :ansi_enabled, true);', " <>
          "test --exclude integration"

      second_task_expected =
        "MIX_ENV=test mix do run -e 'Application.put_env(:elixir, :ansi_enabled, true);', " <>
          "credo"

      expected = first_task_expected <> " && " <> second_task_expected
      assert PortRunner.build_tasks_cmds(config) == expected
    end

    test "take the command cli_executable from passed config" do
      config = %Config{cli_executable: "iex -S mix"}

      expected =
        "MIX_ENV=test iex -S mix do run -e " <>
          "'Application.put_env(:elixir, :ansi_enabled, true);', test"

      assert PortRunner.build_tasks_cmds(config) == expected
    end

    test "respect no-start commandline argument from passed config" do
      config = %Config{cli_args: ["--exclude", "integration", "--no-start"]}

      expected =
        "MIX_ENV=test mix do run --no-start -e " <>
          "'Application.put_env(:elixir, :ansi_enabled, true);', " <>
          "test --exclude integration --no-start"

      assert PortRunner.build_tasks_cmds(config) == expected
    end
  end
end
