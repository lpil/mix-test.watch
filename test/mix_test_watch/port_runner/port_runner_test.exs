defmodule MixTestWatch.PortRunnerTest do
  use ExUnit.Case, async: true

  alias MixTestWatch.PortRunner
  alias MixTestWatch.Config

  describe "build_tasks_cmds/1" do
    test "appends commandline arguments from passed config" do
      config = %Config{cli_args: ["--exclude", "integration"]}

      expected = "ELIXIR_ERL_OPTIONS=\"-elixir ansi_enabled true\" mix test --exclude integration"

      assert PortRunner.build_tasks_cmds(config) == expected
    end

    test "take the command cli_executable from passed config" do
      config = %Config{cli_executable: "iex -S mix"}

      expected = "ELIXIR_ERL_OPTIONS=\"-elixir ansi_enabled true\" iex -S mix test"

      assert PortRunner.build_tasks_cmds(config) == expected
    end

    test "respect no-start commandline argument from passed config" do
      config = %Config{cli_args: ["--exclude", "integration", "--no-start"]}

      expected =
        "ELIXIR_ERL_OPTIONS=\"-elixir ansi_enabled true\" mix " <>
          "test --exclude integration --no-start"

      assert PortRunner.build_tasks_cmds(config) == expected
    end
  end
end
