defmodule MixTestWatch.PortRunnerTest do
  use ExUnit.Case, async: true

  alias MixTestWatch.PortRunner
  alias MixTestWatch.Config

  describe "build_tasks_cmds/1" do
    test "appends commandline arguments from passed config" do
      config = %Config{ cli_args: "test/mix_test_watch/a_test.exs:15" }
      expected = "MIX_ENV=test mix do run -e "
        <> "'Application.put_env(:elixir, :ansi_enabled, true);', "
        <> "test test/mix_test_watch/a_test.exs:15"
      assert PortRunner.build_tasks_cmds(config) == expected
    end

    test "take the command cli_executable from passed config" do
      config = %Config{ cli_executable: "iex -S mix" }
      expected = "MIX_ENV=test iex -S mix do run -e "
              <> "'Application.put_env(:elixir, :ansi_enabled, true);', test"
      assert PortRunner.build_tasks_cmds(config) == expected
    end
  end
end
