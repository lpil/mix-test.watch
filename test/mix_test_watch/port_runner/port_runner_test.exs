defmodule MixTestWatch.PortRunnerTest do
  use ExUnit.Case, async: false

  alias MixTestWatch.PortRunner
  alias MixTestWatch.Config

  setup context do
    if (Map.has_key?(context, :ansi)) do
      old_state = Application.get_env(:elixir, :ansi_enabled)
      Application.put_env(:elixir, :ansi_enabled, context.ansi)
      on_exit(fn -> Application.put_env(:elixir, :ansi_enabled, old_state) end)
    end

    context
  end

  describe "build_tasks_cmds/1" do
    test "builds the right command for windows" do
      assert {"cmd", args} = PortRunner.build_tasks_cmds({:win32, 10}, %Config{})
      refute is_nil(args)
      assert Enum.at(args, 0) === "/c"
      assert Enum.at(args, 1) =~ ~r(^set MIX_ENV=test)
      assert Enum.at(args, 1) =~ ~r( test$)
    end

    test "builds the right command for non-windows" do
      assert {"sh", args} = PortRunner.build_tasks_cmds({:macos, 10}, %Config{})
      refute is_nil(args)
      assert Enum.at(args, 0) === "-c"
      assert Enum.at(args, 1) =~ ~r(^MIX_ENV=test)
      assert Enum.at(args, 1) =~ ~r( test$)
    end

    @tag ansi: true
    test "ANSI is preserved when on in runner" do
      assert {_, args} = PortRunner.build_tasks_cmds({:macos, 10}, %Config{})
      assert Enum.at(args, 1) =~ ~r/Application.put_env\(:elixir, :ansi_enabled, true\)/
    end

    @tag ansi: false
    test "ANSI isn't enabled when off in runner" do
      assert {_, args} = PortRunner.build_tasks_cmds({:macos, 10}, %Config{})
      refute Enum.at(args, 1) =~ ~r/Application.put_env\(:elixir, :ansi_enabled, true\)/
    end

    test "appends commandline arguments from passed config" do
      config = %Config{cli_args: ["--exclude", "integration"]}
      assert {_, args} = PortRunner.build_tasks_cmds({:macos, 10}, config)
      assert Enum.at(args, 1) =~ ~r/--exclude integration$/
    end

    test "take the command cli_executable from passed config" do
      config = %Config{cli_executable: "iex -S mix"}
      assert {_, args} = PortRunner.build_tasks_cmds({:macos, 10}, config)
      assert Enum.at(args, 1) =~ ~r/iex -S mix/
    end
  end
end
