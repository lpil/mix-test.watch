defmodule MixTestWatch.PortRunnerTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

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

  test "run/1 executes all tasks regardless of exit code" do
    config = %Config{tasks: ["fail", "success"]}

    assert capture_io(fn -> PortRunner.run(config) end) =~ "success"
  end
end
